Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4D0E27F4E
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 16:41:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CA6F5AC005
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 14:41:58 -0700 (PDT)
Message-ID: <520D4B1B.4080602@redhat.com>
Date: Thu, 15 Aug 2013 22:41:47 +0100
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 48/49] xfs: Add read-only support for dirent filetype field
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-49-git-send-email-david@fromorbit.com>
	<51F80FA8.4060304@sgi.com> <20130812005905.GK12779@dastard>
	<5208E243.9080403@sgi.com> <20130813005024.GS12779@dastard>
	<520A53E8.6030604@sgi.com> <20130814075042.GE6023@dastard>
	<20130814184729.GA4604@sgi.com> <520C6E39.7030501@redhat.com>
	<20130815180400.GF3783@sgi.com>
In-Reply-To: <20130815180400.GF3783@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Geoffrey Wehrman <gwehrman@sgi.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On 08/15/2013 07:04 PM, Geoffrey Wehrman wrote:
> On Thu, Aug 15, 2013 at 06:59:21AM +0100, Ric Wheeler wrote:
> |
> | As much as the community admires your brave willingness to protect us from
> | code that was entirely developed by Dave, that is not really how the
> | upstream kernel works.
> |
> | Dave is pretty much without equal in moving XFS along these days and this
> | is a key feature that we are depending on.
> |
> | Please don't try to create hurdles to other people getting work into
> | upstream, that kind of thing will lead to a fork of the XFS code base and
> | ultimately that will be harder for all of us.
> |
> | It sounds like what you really should look at doing is to work inside of
> | SGI to create a private, internal branch of the upstream code that you
> | deliver in your product. Upstream code is all about innovation and new
> | features, we don't let vendor specific, non-upstream branches become the
> | place for hardening our code.
>
> I agree Dave is a gifted, dedicated, passionate and prolific contributor
> to the XFS community.  His contributions are greatly appreciated as are
> the contributions of all other members of the XFS community.  Dave does
> stand out as the most significant code contributor to the project.  He
> has played a significant role moving XFS forward both from within SGI
> and from outside SGI.  This does not place his contributions beyond
> review or discussion however.
>
> My objection to the current readdir filetype field feature code is that
> the feature is not being made available to mainstream XFS users, only
> to those willing to run experimental code.  Dave has clearly stated that
> he will not do the back-porting work.  I am not expecting Dave to do the
> back-porting work.  Mark has volunteered to fill the back-porting role.
> Th porting work cannot be completed as the feature is not yet complete.
> The associated user space code changes have not been submitted,
> and tests to validate the new feature have not been submitted.  I do
> not consider this to be an unreasonable request, even if there were
> back-porting required.
>
> If Red Hat is depending on the readdir filetype field feature from Dave
> and do not wish to wait for the feature to be completed before pulling
> in the code, then perhaps Red Hat should create a internal branch of
> the upstream code that you can deliver in your products.  The upstream
> code should be stable and fully functional, not a place for incomplete,
> partially tested, half finished work.
>
>

I think that you are still unclear on what "mainstream" users are.

People who pay for commercial support use vendor branches of the kernel (from 
us, from SLES, from you, etc).

Upstream users and community distros normally expect to see new features in 
their kernels.

For what it's worth, Red Hat has been the largest contributor to XFS for quite a 
while now & XFS will be our RHEL7 default file system.

We don't ship "untested" or "incomplete" code.

Regards,

Ric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
