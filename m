Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p570iqEl257375 for <xfs@oss.sgi.com>; Mon, 6 Jun 2011 19:44:53 -0500
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C37615DE865
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2011 17:44:51 -0700 (PDT)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id 9cvXpG6tdn4A2WiT for
	<xfs@oss.sgi.com>; Mon, 06 Jun 2011 17:44:51 -0700 (PDT)
Date: Mon, 6 Jun 2011 20:44:45 -0400
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 1/3 v5] XFS TESTS: Add Punch Hole to FSX
Message-ID: <20110607004445.GG20818@thunk.org>
References: <4DED63D1.5010600@vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DED63D1.5010600@vnet.ibm.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Allison Henderson <achender@vnet.ibm.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jun 06, 2011 at 04:33:37PM -0700, Allison Henderson wrote:
> This patch adds punch hole tests to the fsx stress test. 
> 
> Signed-off-by: Allison Henderson <achender@us.ibm.com>
> 

Hey Allison, there are two things you can do that will make life much
easier for people to review and apply your patches.  First of all,
move the version information below to after the "---" line.  If you
want to keep this information in the git commit log, just move the
"---" line after you run the "git format-patch" command.

Secondly, run the command "git config format.thread true"; this is the
default in newer versions of git, but apparently you're not using a
new enough version of git.  You can also use "git send-email --thread"
if you don't want to set the git configuration variable.  The other
possibility is that your mailer is stripping the in-reply-to: and
references: header, so the mail threading is disappearing.  I never
used vnet.ibm.com's mailer, so I don't know if it's responsible for
stripping mail headers, but I tend not to trust VM or Lotus Notes'
standard adherence... fortunately for IBM the CIO's who make the
purchasing decisions tend not to know the first thing about Internet
Mail Standers or RFC's.  :-)

		       	      	       - Ted

> v1 -> v2:
> Corrections to the Makefile have been backed out.
> This patch needs to be applied on top of
> the "xfstests: clean up fallocate configuration tests"
> patch
> 
> The punch hole tests can be disabled with the
> -H flag, and will also be disabled if it is
> detected that the filesystem does not support
> punch hole
> 
> v2 -> v4
> Punch hole tests and functionality tests have been moved
> into their own functions.  Existing dofallocate routine
> has been renamed to do_preallocate.
> 
> v4 -> v5
> The code to test fallocate functionality changed slightly,
> so the patch has been updated to apply with out err
> ---
> :100644 100644 0eebc70... 0683853... M	ltp/fsx.c
>  ltp/fsx.c |  143 ++++++++++++++++++++++++++++++++++++++++++++++++++++--------
>  1 files changed, 124 insertions(+), 19 deletions(-)
> 
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 0eebc70..0683853 100644
...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
