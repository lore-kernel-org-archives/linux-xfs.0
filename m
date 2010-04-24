Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3OGgYh8166659 for <xfs@oss.sgi.com>; Sat, 24 Apr 2010 11:42:34 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB50E1321437
	for <xfs@oss.sgi.com>; Sat, 24 Apr 2010 09:44:33 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.9])
	by cuda.sgi.com with ESMTP id QnYgShKfCct74rra for
	<xfs@oss.sgi.com>; Sat, 24 Apr 2010 09:44:33 -0700 (PDT)
From: "Hans-Peter Jansen" <hpj@urpla.net>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
	[bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Date: Sat, 24 Apr 2010 18:44:22 +0200
References: <201004050049.17952.hpj@urpla.net> <20100413091823.GD7544@dastard>
	<201004131142.33518.hpj@urpla.net>
In-Reply-To: <201004131142.33518.hpj@urpla.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201004241844.23482.hpj@urpla.net>
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
To: xfs@oss.sgi.com
Cc: Nick Piggin <npiggin@suse.de>, opensuse-kernel@opensuse.org, Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org

On Tuesday 13 April 2010, 11:42:33 Hans-Peter Jansen wrote:
> On Tuesday 13 April 2010, 11:18:23 Dave Chinner wrote:
> > On Tue, Apr 13, 2010 at 10:50:35AM +0200, Hans-Peter Jansen wrote:
> > > Dave, may I ask you kindly for briefly elaborating on the worst
> > > consequences of just reverting this hunk, as I've done before?
> >
> > Well, given that is the new shrinker code generating the warnings,
> > reverting/removing that hunk will render the patch useless :0
>
> Excuse me, I didn't express myself well. I'm after the consequences of
> applying the revert, that I posted a few messages above.
>
> > I'll get you a working 2.6.33 patch tomorrow - it's dinner time
> > now....
>
> Cool, thanks.

Obviously and not totally unexpected, really fixing this is going to take 
more time.

FYI, 2.6.33.2 is still affected from this issue. 

Greg, you might search for a server using xfs filesystems and and a i586 
kernel >= 2.6.33, (2.6.32.11 of SLE11-SP1 will serve as well), log in as an 
ordinary user, do a "du" on /usr, and wait for the other users screaming...

BTW, all affected kernels, available from 
http://download.opensuse.org/repositories/home:/frispete: have the 
offending patch reverted (see subject), do run fine for me (on this 
aspect).

Will you guys pass by another round of stable fixes without doing anything 
on this issue?

Dave, this is why I'm kindly asking you: what might be the worst 
consequences, if we just do the revert for now (at least for 2.6.33), until 
you and Nick came to a final decision on how to solve this issue in the 
future.

Just a brief note would be fine.

Cheers,
Pete

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
