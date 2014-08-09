Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B30B47F81
	for <xfs@oss.sgi.com>; Sat,  9 Aug 2014 13:58:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4FF65AC001
	for <xfs@oss.sgi.com>; Sat,  9 Aug 2014 11:58:50 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id wgveUCamjTHWMVXX for <xfs@oss.sgi.com>;
	Sat, 09 Aug 2014 11:58:47 -0700 (PDT)
References: <CA+o=1OVY0pV18XMKz98dT5LGwE500DQQb5B1wh=HaGTAGuP+oQ@mail.gmail.com>
	<20140809005404.GG26465@dastard>
	<CA+o=1OX+Qq4Scq=su1MDDknRXJGL8F=7WV8P0PCeDjYep7rLnA@mail.gmail.com>
	<CA+o=1OXmM+WsFh-ipS4d8hn6RKvOuv3Zga+66PF4DBehuH-5-A@mail.gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <CA+o=1OXmM+WsFh-ipS4d8hn6RKvOuv3Zga+66PF4DBehuH-5-A@mail.gmail.com>
Message-Id: <8864B382-ABD4-484E-A1D1-C2CB96F46810@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Verifier fixes backported to stable kernels?
Date: Sat, 9 Aug 2014 11:58:42 -0700
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
To: Fanael Linithien <fanael4@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Aug 9, 2014, at 8:55 AM, Fanael Linithien <fanael4@gmail.com> wrote:
> 
> 2014-08-09 2:54 GMT+02:00 Dave Chinner <david@fromorbit.com>:
>> What fixes are you talking about? List of commits, please, noting
>> whether the commit already has a "cc: <stable@vger.kernel.org>" in
>> it or not.
> 
> These are the commits:
> 
> 400b9d88757c0bfbdfa97014e090ec40a31c1282
> 67dc288c21064b31a98a53dc64f6b9714b819fd6 (this is the only one with the cc)
> 5fd364fee81a7888af806e42ed8a91c845894f2d
> ad3714b82c631a34724da09a7daa53afcab952fa
> 
>> Patch your kernel with the fixes you've identified are necessary,
>> then - it can take some time for fixes to propagate through the
>> stable process....
> 
> This is what I'm trying to avoid, out of sheer laziness. I suppose I'm
> going to have to do that if I want to have a working linux, though.
> 
In what way did this "eat" your root fs?  What happened?  Also, are you using a CRC-enabled filesystem?

-Eric
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
