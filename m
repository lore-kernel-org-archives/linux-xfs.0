Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CD0797F3F
	for <xfs@oss.sgi.com>; Sat, 26 Oct 2013 22:29:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AB1F88F8039
	for <xfs@oss.sgi.com>; Sat, 26 Oct 2013 20:29:09 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id MRZVRGjonUDp1VQs for <xfs@oss.sgi.com>;
	Sat, 26 Oct 2013 20:29:08 -0700 (PDT)
Message-ID: <526C8882.2090909@sandeen.net>
Date: Sat, 26 Oct 2013 22:29:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Questions about XFS
References: <CAD+1EGPG1G9Q8kwaSUjxVjvx73UByLb3G0rmUbgJr+zD-CnjEw@mail.gmail.com>	<20131025164255.46d2829c@harpe.intellique.com>	<526A86F2.9070400@sandeen.net>
	<526B9C55.9000707@hardwarefreak.com>
In-Reply-To: <526B9C55.9000707@hardwarefreak.com>
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
To: stan@hardwarefreak.com, xfs@oss.sgi.com

On 10/26/13 5:41 AM, Stan Hoeppner wrote:
> On 10/25/2013 9:57 AM, Eric Sandeen wrote:
> 
>> allocator, but it doesn't have GRIO (Guaranteed Realtime I/O) like 
>> IRIX does.
> 
> Wasn't it called "Guaranteed-Rate I/O"?  

Yeah, you are right.  Brain fart.

> And required the Origin ccNUMA
> hardware including the HUB and XBow ASICs?  IIRC this had no real-time
> guarantee, but simply reserved X amount of bandwidth from the XBow
> through the HUB to the processor, and finally the kernel and process.
> Whether the attached disks could sustain the reserved bandwidth was
> another matter.

There were 2 versions, implemented in very different ways...

Anyway, if Harry would "prefer designing and implementing" it for Linux,
I'll just let him get started.  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
