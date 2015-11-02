Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1EF127F5E
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 21:41:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9E142AC002
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 19:41:34 -0800 (PST)
Received: from mail-lf0-f48.google.com (mail-lf0-f48.google.com
	[209.85.215.48]) by cuda.sgi.com with ESMTP id EKVUbQRPdcEvQMbA
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 01 Nov 2015 19:41:31 -0800 (PST)
Received: by lfgh9 with SMTP id h9so9431352lfg.1
	for <xfs@oss.sgi.com>; Sun, 01 Nov 2015 19:41:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151102025352.GY19199@dastard>
References: <1446217508-22157-1-git-send-email-agruenba@redhat.com>
	<20151102025352.GY19199@dastard>
Date: Mon, 2 Nov 2015 04:41:30 +0100
Message-ID: <CAHc6FU7As8=jA7FMC0N_gDuECxeb15iKn=uXpu2b57LHtcFPaA@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] xfs: SGI ACL Fixes
From: Andreas Gruenbacher <agruenba@redhat.com>
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
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Mon, Nov 2, 2015 at 3:53 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Oct 30, 2015 at 04:05:03PM +0100, Andreas Gruenbacher wrote:
>> Here is a reworked patch queue that also handles setting SGI_ACL_{FILE,DEFAULT}
>> via XFS_IOC_ATTRMULTI_BY_HANDLE.  Please review.
>>
>> Thanks,
>> Andreas
>>
>> Andreas Gruenbacher (5):
>>   xfs: Validate the length of on-disk ACLs
>>   xfs: Plug memory leak in xfs_attrmulti_attr_set
>
> Ok, I've taken these two patches for the upcoming merge window as
> they fix bugs, but I've taken Brian's cached ACL invalidation patch
> instead of these:
>
>>   xfs: SGI ACLs: Fix caching and mode setting
>>   xfs: Add namespace parameter to the xfs kuid/kgid <=> uid/gid wrappers
>>   xfs: SGI ACLs: Map uid/gid namespaces
>
> I'm not yet convinced that these patches are the right way to solve
> the given issue as they may interact badly with xfsdump/restore.

Well, what else do you need to be convinced? I guess it won't help if
I try to explain everything all over again?

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
