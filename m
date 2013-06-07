Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 81B907F37
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 00:26:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 62929304082
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 22:26:02 -0700 (PDT)
Received: from esmtp1.es.uci.edu (esmtp1.es.uci.edu [128.195.153.131]) by
	cuda.sgi.com with ESMTP id PGRONNgPbVtSaTs8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 22:25:58 -0700 (PDT)
Received: from mail-wg0-f54.google.com (mail-wg0-f54.google.com [74.125.82.54])
	(authenticated bits=0)
	by esmtp1.es.uci.edu (8.13.8/8.13.8) with ESMTP id r575Ps4Q426339
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <xfs@oss.sgi.com>; Thu, 6 Jun 2013 22:25:57 -0700
Received: by mail-wg0-f54.google.com with SMTP id j13so2823599wgh.9
	for <xfs@oss.sgi.com>; Thu, 06 Jun 2013 22:25:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130607035046.GJ29338@dastard>
References: <CAO9TOLffaO62ZtvchpKnnORuNd0GJMsqKDeAhmdSQ1mnFn1EpA@mail.gmail.com>
	<20130607035046.GJ29338@dastard>
Date: Thu, 6 Jun 2013 22:25:53 -0700
Message-ID: <CAO9TOLeJHvWXqwp8eATUuqV3Y_b_kH85CmCmxH5amJ0E_6+3+A@mail.gmail.com>
Subject: Re: XFS Adding Quotas - Skip Quota check on first mount/boot
From: Adam Brenner <aebrenne@uci.edu>
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
Cc: xfs@oss.sgi.com

>> We run a 14TB XFS fileserver on our cluster and want to add quota
>> support. This is running 3.9.2-1.el6.elrepo.x86_64 kernel under CentOS
>> 6.3 (Final).
>
> How many files in the filesystem?

8,339,620 files. 11TB used / 14TB total. 8MB Used / 11GB inodes.

(on a different server below)
8,878,507 files. 2.1TB used / 5.5TB total. 9.3MB Used / 1.1GB inodes.

Not that many compared to our larger file systems (already have quotas
enabled). But still a lot of files.

> You can't. quotacheck relies on exclusive access to the filesystem,
> and so the mount cannot process until it completes. Quotas need to
> be consistent before you can start using the filesystem....
>
> Now, there's the possibility that we could parallelise quotacheck
> because it uses bulkstat for iteration, but somebody would have to
> find the time to do that and it won't solve your immediate problem.
>
> Hence I suggest just waiting for it to complete - if you have
> millions of inodes it could hours to complete, so just let it go
> overnight...

Okay. Thanks for the information Dave! The servers we have are
critical in that having downtime causes a lot of unhappy users. Since
the XFS mount point is not accessible, everything that depends on it
needs to be taken offline -- for example users's home directories.

I was trying to research a way to avoid such a thing, but doesn't seem
like I can. I would be interested to know, and maybe others on the
listsrv can chime in, on what sort of time period I can expect for the
quota check to run with 8 million files. Performing some martian math
I get something like 4 hours? Maybe I should switch planets :-)

--
Adam Brenner
Computer Science, Undergraduate Student
Donald Bren School of Information and Computer Sciences

Research Computing Support
Office of Information Technology
http://www.oit.uci.edu/rcs/

University of California, Irvine
www.ics.uci.edu/~aebrenne/
aebrenne@uci.edu


On Thu, Jun 6, 2013 at 8:50 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Jun 06, 2013 at 07:59:34PM -0700, Adam Brenner wrote:
>> Howdy XFS Devs,
>>
>> We run a 14TB XFS fileserver on our cluster and want to add quota
>> support. This is running 3.9.2-1.el6.elrepo.x86_64 kernel under CentOS
>> 6.3 (Final).
>
> How many files in the filesystem?
>
>> The issue is when we unmount the XFS RAID, and re-mount it adding
>> quota support, the mount command hangs.
>
> It won't have hung, it will just be busy doing a quotacheck.
>
>> Sever IS responsive and the
>> XFS mount point is not accessible. Reverting our changes in /etc/fstab
>> to remove the quota options does not have mount hang.
>
> Because it doesn't do a quotacheck.
>
>> I suspect that upon re-mount, XFS is running a quota check on the 14TB
>> RAID. My question is: how do I disable the initial quota check so it
>> can mount it properly and have quota check run in the background?
>
> You can't. quotacheck relies on exclusive access to the filesystem,
> and so the mount cannot process until it completes. Quotas need to
> be consistent before you can start using the filesystem....
>
> Now, there's the possibility that we could parallelise quotacheck
> because it uses bulkstat for iteration, but somebody would have to
> find the time to do that and it won't solve your immediate problem.
>
> Hence I suggest just waiting for it to complete - if you have
> millions of inodes it could hours to complete, so just let it go
> overnight...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
