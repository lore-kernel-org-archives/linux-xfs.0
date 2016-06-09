Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8C5EB7CA7
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 11:51:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 517D48F8035
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 09:51:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id uLjVndBJqwn3GEN8 for <xfs@oss.sgi.com>;
	Thu, 09 Jun 2016 09:51:13 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 620A84A6
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 11:51:13 -0500 (CDT)
Subject: Re: [PATCH 0/4] xfs: online relabeling [RFC]
References: <c1922d3d-208c-3699-0a36-26108a4f44de@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2305b486-f336-6d1e-9420-b69dc5bdc572@sandeen.net>
Date: Thu, 9 Jun 2016 11:51:12 -0500
MIME-Version: 1.0
In-Reply-To: <c1922d3d-208c-3699-0a36-26108a4f44de@sandeen.net>
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
To: xfs@oss.sgi.com



On 6/9/16 11:36 AM, Eric Sandeen wrote:
> Ok, this more or less works; not really up to snuff
> for submission or merging, just sketching it out, but some
> questions first:
> 
> 1) Is there really any point to this? :) We did have one
>    request, and btrfs can do it ...
> 
> 2) Is using m_growlock horrible?  growfs is the only other
>    thing that writes all supers, so I grabbed it.  We don't
>    want multiple relabels stepping on each other.
> 
> 3) Is there some way to actually force the primary to disk?
>    Right now the label change isn't actually visible on the
>    primary until unmount, which defeats the purpose.  I'm not
>    sure if there's a straightforward/safe way to make it
>    visible...

Oh, sorry - I guess it is getting written out, but it's only
available via an O_DIRECT read from userspace; it's not
invalidating the cache.

# io/xfs_io -c "label derp" /mnt/test
label = "derp"

# dd if=/dev/sdb2 bs=512 count=1 | hexdump -C
...
00000060  00 00 0a 00 b4 e5 02 00  02 00 00 08 66 6f 6f 00  |............foo.|
...

# dd if=/dev/sdb2 iflag=direct bs=512 count=1 | hexdump -C
...
00000060  00 00 0a 00 b4 e5 02 00  02 00 00 08 64 65 72 70  |............derp|
...

# dd if=/dev/sdb2 bs=512 count=1 | hexdump -C
...
00000060  00 00 0a 00 b4 e5 02 00  02 00 00 08 66 6f 6f 00  |............foo.|
...

Guess I need to think about this some more.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
