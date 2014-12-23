Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 96DA829DF7
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 20:42:56 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 268E8AC003
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 18:42:53 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	9TKFiByCx03LUi1E for <xfs@oss.sgi.com>;
	Mon, 22 Dec 2014 18:42:50 -0800 (PST)
Date: Tue, 23 Dec 2014 13:42:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: weird quota issue
Message-ID: <20141223024248.GC4521@dastard>
References: <3BD1EE39-8C26-4C5B-94B5-492422EECEDA@mail.nih.gov>
	<20141222204857.GK24183@dastard>
	<6F43BF63-A44E-43F6-A184-9AAC10DDDFDF@grc.nia.nih.gov>
	<20141222223540.GS15665@dastard>
	<2F3F57BB-59EA-4FF9-9254-6A598DE7AC46@grc.nia.nih.gov>
	<20141223003237.GA4521@dastard>
	<258BE536A650F646814BA46CC06568980F6A8AD7@msgb01.nih.gov>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <258BE536A650F646814BA46CC06568980F6A8AD7@msgb01.nih.gov>
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
To: "Weber, Charles (NIH/NIA/IRP) [E]" <WeberC@grc.nia.nih.gov>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Dec 23, 2014 at 02:12:15AM +0000, Weber, Charles (NIH/NIA/IRP) [E] wrote:
> here you go
> 
> # xfs_db -c "inode 131" -c p /dev/dm-7

Nothing obviously wrong there, so there's no clear indication of why
the quota initialisation failed. If hasn't got to quotacheck,
because theat throws verbos errors when it fails, so it's something
going wrong during initialisation.

Just to narrow it down, if you mount with just uquota does the
mount succeed? Please post the dmesg output whatever the outcome.
Does mounting with just pquota succeed? If neither succeed, what
happens if you mount with no quotas, then unmount and mount again
with quotas enabled?

If it still doesn't work, I'm going to need an event trace of a
failed mount (install trace-cmd and run:

# trace-cmd record -e xfs\* mount -o uquota,pquota /dev/dm-7 /mnt/pt
<some output>
# trace-cmd report > trace.out

And then compress the trace.out file and attach it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
