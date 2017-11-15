Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36518 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751155AbdKOHlf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Nov 2017 02:41:35 -0500
Date: Wed, 15 Nov 2017 15:41:33 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v3] common: Check for fiemap range argument support
Message-ID: <20171115074133.GN17339@eguan.usersys.redhat.com>
References: <20171102031622.GV17339@eguan.usersys.redhat.com>
 <1509610421-16716-1-git-send-email-nborisov@suse.com>
 <cb9fba60-a000-d08a-5099-3aa604724568@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb9fba60-a000-d08a-5099-3aa604724568@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Nov 14, 2017 at 09:09:21AM -0600, Eric Sandeen wrote:
> 
> 
> On 11/2/17 3:13 AM, Nikolay Borisov wrote:
> > From: Nikolay Borsiov <nborisov@suse.com>
> > 
> > Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> > ---
> > v3:
> >  * Changed the way we detect ranged args. Now use a regexp which checks 
> >  explicitly for the ranged args
> >  common/rc | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/common/rc b/common/rc
> > index e2a8229..f7a5fe9 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -2053,8 +2053,15 @@ _require_xfs_io_command()
> >  			-c "$command 4k 8k" $testfile 2>&1`
> >  		;;
> >  	"fiemap")
> > +		if echo "$param" | egrep -q "[[:digit:]]+[bskmgtpe]? [[:digit:]]+[bskmgtpe]?$"
> > +		then
> > +			$XFS_IO_PROG -c "help fiemap" | head -n 1 | grep -q "[offset [len]]" || \
> > +				_notrun "xfs_io $command range param support is missing"
> > +		fi
> > +
> 
> What if, rather than difficult to read regexps, we actually checked the functionality?
> The check already writes a testfile; you could try fiemapping past EOF and see what
> you get, i.e. for a file in a single 4k block:
> 
> $ io/xfs_io -c "fiemap" short
> short:
> 	0: [0..7]: 2788960..2788967
> 
> Mapping past EOF will give you no extents (if the range values are honored by the
> command):
> 
> $ io/xfs_io -c "fiemap 4k 4k" short
> short:

Yeah, I'm OK with it, looks better than the complicated regexp and could
keep the fiemap command interface simpler.

> 
> >  		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
> >  			-c "fiemap -v $param" $testfile 2>&1`
> 
> so I think you could switch based on [ -n $param ] about whether we were asked
> to check a range and if so, map past EOF, and return success or fail based
> on what you get back.  The only slight weirdness is that you're asking to check
> a specific range (_require_xfs_io_command "fiemap" "0 4k") but possibly testing
> a different one ("20k 4k") but not sure if that matters.
> 
> It'd be a bit of a departure but with enough comments, maybe ok to do it as:
> 
> _require_xfs_io_command "fiemap" "ranged"
> 
> and use the "ranged" param to DTRT in the test.

This looks fine too to me.

Thanks,
Eryu

> 
> -Eric
> 
> > +
> >  		param_checked=1
> >  		;;
> >  	"flink" )
> > 
