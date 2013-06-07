Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A08927F3F
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 01:36:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2B053AC002
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 23:36:45 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id DqbPj86cOTh9SEGR
	for <xfs@oss.sgi.com>; Thu, 06 Jun 2013 23:36:44 -0700 (PDT)
Message-ID: <51B17F7F.8010500@hardwarefreak.com>
Date: Fri, 07 Jun 2013 01:36:47 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS Adding Quotas - Skip Quota check on first mount/boot
References: <CAO9TOLffaO62ZtvchpKnnORuNd0GJMsqKDeAhmdSQ1mnFn1EpA@mail.gmail.com>
	<20130607035046.GJ29338@dastard>
In-Reply-To: <20130607035046.GJ29338@dastard>
Reply-To: stan@hardwarefreak.com
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Adam Brenner <aebrenne@uci.edu>, xfs@oss.sgi.com

On 6/6/2013 10:50 PM, Dave Chinner wrote:

> Hence I suggest just waiting for it to complete - if you have
> millions of inodes it could hours to complete, so just let it go
> overnight...

> On Thu, Jun 06, 2013 at 07:59:34PM -0700, Adam Brenner wrote:

> I do not mind high CPU usage or slow performance while the mount point
> is active, but having it unavailable is not an option we would like
> stick with. I suspect running quota check on 14TB would take roughly a
> full work day and then some.

Hi Adam,

This 14TB XFS is the mpc-data1 workspace (/w1/$USER), correct?  User
compute cluster jobs access this filesystem 24x7, correct?  So to allow
for the remount quotacheck to complete you will need to have users move
jobs to the 40TB mpc-data2 workspace, or another temporary workspace,
until /w1 is accessible again.  Or, their jobs simply must wait until
quotacheck completes.  Or?

As Dave said there's no way around the initial quotacheck.  If you
provide the file count Dave requested he may be able to provide a rough
estimate of completion time.  This may benefit your outage planning.
I.e. it make complete much sooner than you currently guess, or it may
actually take substantially longer.  I learned long ago that when devs
and experienced users on this mailing list ask for information, there's
a good reason.  Thus it's best to answer all questions.  You skipped
this one.

FWIW, I just checked mount(8), the XFS FAQ, User Guide, and Training
Labs, and I could not find a caveat or warning WRT mount time when
enabling quotas on existing filesystems.  Dave, might this be suitable
for the FAQ?  I'd guess many users have no idea the entire filesystem
must be walked when quota is enabled, since most enable it on freshly
made XFS.  Could we add to the end of this something like below?
http://www.xfs.org/index.php/XFS_FAQ#Q:_Quota:_Do_quotas_work_on_XFS.3F

"A check is run at mount after enabling quotas.  If you already have
many files this will take some time: multiple hours with millions of
files.  During this time the filesystem is unavailable."

I don't believe I ever got an account, so I don't think I can make
edits.  If this is a bad suggestion, maybe that's why I have no acct. ;)

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
