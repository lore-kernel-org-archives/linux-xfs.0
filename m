Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B6A6C7F3F
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 07:10:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4FB72AC00A
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 05:10:09 -0800 (PST)
Received: from mail-pb0-f54.google.com (mail-pb0-f54.google.com
	[209.85.160.54]) by cuda.sgi.com with ESMTP id q1ljzLRu81KOPbVB
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Nov 2013 05:10:05 -0800 (PST)
Received: by mail-pb0-f54.google.com with SMTP id ro12so2010319pbb.13
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 05:10:05 -0800 (PST)
Received: from [172.20.3.35] ([59.10.106.2]) by mx.google.com with ESMTPSA id
	sg1sm51517078pbb.16.2013.11.14.05.10.03 for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Thu, 14 Nov 2013 05:10:04 -0800 (PST)
Message-ID: <5284CB99.6030702@gmail.com>
Date: Thu, 14 Nov 2013 22:09:45 +0900
From: Ric Wheeler <ricwheeler@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH RFC] xfs: set block device logical sector size on
	xfs_buftarg
References: <5283C41D.7070503@redhat.com> <52841AB9.9050906@sandeen.net>
	<20131114064932.GO6188@dastard>
In-Reply-To: <20131114064932.GO6188@dastard>
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
To: xfs@oss.sgi.com


(large snip)

On 11/14/2013 03:49 PM, Dave Chinner wrote:
>> (I'm sympathetic to pushing the envelope and dragging apps into the 21st
>> >century, but it's s double edged sword).
> Yes, it is, but if we don't take a stand and say "we, as an
> ecosystem, need to support 4k sectors*everywhere*", then we are
> going to have such problems*forever*. This isn't purely an XFS
> problem - this is something that the entire storage stack needs to
> support, from the hardware at the very bottom to the applications at
> the very top.
>
> XFS is stuck in the middle, where we cop it from both
> the hardware side ("why don't you support our hardware efficiently
> yet?") and from the application side when we do ("4k sectors break
> our assumptions!"). It's a no win situation for us no matter what we
> do, and history has shown that when we don't take a strong
> leadership position the problems don't get solved.
>
> So, let's take the initiative and make sure that everyone knows how
> to deal with these problems and get them fixed in the right places.
> I don't want to be spending the next 10 years complaining about a
> lack of 4k sector support in qemu. It's too much like the inode64
> saga over all over again.
>
> Let's face it, it wouldn't be right if XFS wasn't fighting some
> battle to drag Linux kicking and screaming into the present...
>
> Cheers,
>
> Dave.

I would agree that we should not to hit our 4K sector support, have we reached 
out the the KVM/QEMU people to see if we can get them to fix this on their side?

Ric



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
