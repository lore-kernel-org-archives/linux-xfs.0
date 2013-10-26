Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 76D387F3F
	for <xfs@oss.sgi.com>; Sat, 26 Oct 2013 05:41:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 62C258F8039
	for <xfs@oss.sgi.com>; Sat, 26 Oct 2013 03:41:32 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id QDzm4pkdRtVWcetK
	for <xfs@oss.sgi.com>; Sat, 26 Oct 2013 03:41:28 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id DC24A6C158
	for <xfs@oss.sgi.com>; Sat, 26 Oct 2013 05:41:27 -0500 (CDT)
Message-ID: <526B9C55.9000707@hardwarefreak.com>
Date: Sat, 26 Oct 2013 05:41:25 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Questions about XFS
References: <CAD+1EGPG1G9Q8kwaSUjxVjvx73UByLb3G0rmUbgJr+zD-CnjEw@mail.gmail.com>	<20131025164255.46d2829c@harpe.intellique.com>
	<526A86F2.9070400@sandeen.net>
In-Reply-To: <526A86F2.9070400@sandeen.net>
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
To: xfs@oss.sgi.com

On 10/25/2013 9:57 AM, Eric Sandeen wrote:

> allocator, but it doesn't have GRIO (Guaranteed Realtime I/O) like 
> IRIX does.

Wasn't it called "Guaranteed-Rate I/O"?  And required the Origin ccNUMA
hardware including the HUB and XBow ASICs?  IIRC this had no real-time
guarantee, but simply reserved X amount of bandwidth from the XBow
through the HUB to the processor, and finally the kernel and process.
Whether the attached disks could sustain the reserved bandwidth was
another matter.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
