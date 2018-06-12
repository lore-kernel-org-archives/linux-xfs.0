Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42136 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933658AbeFLQql (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Jun 2018 12:46:41 -0400
Subject: Re: [PATCH v6 0/5] xfsprogs: add mkfs.xfs configuration file parsing
 support
References: <20180612003039.17154-1-mcgrof@kernel.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <dfc1e869-2847-3965-305b-21089472cad5@sandeen.net>
Date: Tue, 12 Jun 2018 11:46:39 -0500
MIME-Version: 1.0
In-Reply-To: <20180612003039.17154-1-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On 6/11/18 7:30 PM, Luis R. Rodriguez wrote:
> This is v6 series addresses the feedback from the last v5 series. The
> biggest change is for dumping the opterr reset onto the shared helper
> platform_getoptreset(), and addressing the TOCTOU race between stat-ing
> and opening. The rest of the changes are all things which were mentioned
> during review, the details listed below.

Ok, I've pushed this to a temporary mkfs-config branch, based
on the current for-next.  I'll send a handful of followup patches
and then other folks who've been watching (djwong, dchinner?) can
send patches or highlight other issues or concerns that are outstanding.

If all goes well we can build up something we're happy with on that
branch and merge it to for-next & hopefully xfsprogs-4.17, yet.

Thanks,
-Eric

> 
> You can also get the code from my kernel.org xfsprogs-dev 20180611-own-parser-v6
> branch [0].
> 
> Reviews, questions, or rants are greatly appreciated.
> 
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/xfsprogs-dev.git/log/?h=20180611-own-parser-v6
> 
> Changes on v6:
> 
> - Use -1 return value consistently when returning
> - Fix use of one errno use
> - Remove &confopts_tab[i] check which can never happen
> - Fixed uninitialized return value use on parse_config_stream()
> - Remove extra tag declaration on parse_config_stream()
> - Address the TOCTOU race
> - Move opterr to shorten the first parameter parsing on main(). We now
>   just use platform_getoptreset() to reset the settings so we can parse
>   more.
> 
> Changes on v5:
> 
> - We no force sysconfdir=/etc if not set so we also drop the last patch
>   for debian as its no longer needed
> 
> - We use config_check_bool() as during review on the last series we
>   failed to pick up on the fact that we were *not* detecting if a value
>   for a field was greater than 1, so we were allowing for instance crc=1
>   although this was silently mapping to crc=1. Note that although this
>   issue was present, the check for conflicts is still in effect and
>   functional. The only reason the issue with bools existed is we cast
>   down the uint64_t to bool and that resolves the issue. For now all
>   subuopt parsers use config_check_bool(). When and if other values are
>   introduced they can change this.
> 
> - Use fstat() and openat() as requested instead of the odd checks for
>   first and second characters. This feels nicer.
> 
> - Use negative return values and fixate errno in better locations.
> 
> - Drop the man pages and yield to Sandeed for that.
> 
> - Re-introduce the source type enum
> 
> - Dealing with a config file is now split into an open call and a
>   separate parse file. This does read much better now.
> 
> - Fix a missing free(line) on the switch for parsing when we don't have
>   an error.
> 
> - Adjust random error messages to reflect a bit better what is issue
>   creeped up.
> 
> Changes on v4:
> 
> - Tons of man page documentation enhancements from Darrick.
> 
> - Adjusted a few error code messages/ paths to make more sense as per
>   Darrick's feedback.
> 
> Changes on v3:
> 
> - Prefix errors on the configuration parsing with config file used and
>   exact line.
> 
> - Use uint64_t throughout all parsers as requested.
> 
> - Parse the CLI early for -c as I originally had implemented this on v1
>   but now platform_getoptreset() to reset the opts.
> 
> - Drop the enum for the source type for the configuration file type,
>   note that since we rely on the stack to set the variables we should
>   then always set the dft.src on main().
> 
> - Use getline() for fetching lines as requested
> 
> - Add a special iscomment() and isempty() to handle all space and
>   comment parsing. Now when PARSE_INVALID issued we really mean it.
> 
> - Embrace latest bikeshed preferences:
>         config.c, config.h, random function names
> 
> - Add man pages to be parsed via configure so that @sysconfigdir@ gets
>   properly parsed
> 
> - get_confopts() now iterates over the known sections tab and gives you
>   the right struct right away.
> 
> - Add respecification checks for a section.
> 
> - Add respecification checks for -c, -c is only allowed once.
> 
> - Add --sysconfigdir to debian/rules, note that if you *don't* set
>   --sysconfigdir your man pages will end up with ${prefix}. We could
>   add a secondary target parsing just in case, or we can do some hacks
>   with autoconf for this, but I don't think its worth it. Other packages
>   deal with this by having ./configure always run with --sysconfigdir
>   set (see systemd for instance).
> 
> - Reduced the number of declared enums, only enums for the config
>   subparams which are currently supported for parsing are declared.
> 
> - mkfs.xfs -c foo now will search for $PWD/foo and if that fails the
>   sysconfigdir/mkfs.xfs.d/foo.
> 
> - mkfs.xfs -c ../foo works and so should ./foo, etc.
> 
> - The MKFS_XFS_CONFIG variable support was dropped in favor or just
>   allowing the user to specify the full path now.
> 
> - Embraces xfsprogs coding style, c'est la vie.
> 
> Changes on v2:
> 
> - Stayed with our own parser as its the smallest and we're willing to
>   maintain it as its simple and clear.
> 
> - Use -c for the configuration file, and drop the "type" nomenclature to
>   avoid confusion on the interwebs.
> 
> - Start to split files off
> 
> - Duplicate a bit of items as suggested at LSFMM for the configuration
>   parser structures. We can later consolidate if we think its really
>   needed, however we want the freedom to change these as we see fit and
>   most importantly keep the code apart.
> 
> - Conflict resolution and validation is managed now by piggy backing off
>   of the idea of using the defaults to instantiate CLI parameters. CLI
>   always overrides.
> 
> Luis R. Rodriguez (5):
>   mkfs: distinguish between struct sb_feat_args and struct cli_params
>   mkfs: move shared config structs and into their own headers
>   mkfs: replace defaults source with an enum
>   xfsprogs: reset opterr on platform_getoptreset()
>   mkfs.xfs: add configuration file parsing support using our own parser
> 
>  configure.ac          |   1 +
>  include/builddefs.in  |   2 +
>  include/darwin.h      |   1 +
>  include/gnukfreebsd.h |   1 +
>  include/linux.h       |   1 +
>  mkfs/Makefile         |   2 +-
>  mkfs/config.c         | 670 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  mkfs/config.h         | 121 +++++++++
>  mkfs/xfs_mkfs.c       | 127 +++++-----
>  9 files changed, 865 insertions(+), 61 deletions(-)
>  create mode 100644 mkfs/config.c
>  create mode 100644 mkfs/config.h
> 
