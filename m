Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p21FkSkt207152 for <xfs@oss.sgi.com>; Tue, 1 Mar 2011 09:46:28 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D3E9C307FB5
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2011 07:49:16 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id hgSU7q1zIA0qkxOQ for <xfs@oss.sgi.com>;
	Tue, 01 Mar 2011 07:49:16 -0800 (PST)
Message-ID: <4D6D157B.9070800@sandeen.net>
Date: Tue, 01 Mar 2011 09:49:15 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfs: zero proper structure size for geometry calls
References: <4D6C28A5.60905@mnsu.edu> <4D6C4DEE.6020902@sandeen.net>	
	<4D6C9958.2040607@sandeen.net> <1298984132.32568.3.camel@dan>
	<4D6D128C.6010503@mnsu.edu>
In-Reply-To: <4D6D128C.6010503@mnsu.edu>
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
To: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Eugene Teo <eugeneteo@kernel.org>, xfs@oss.sgi.com

On 3/1/11 9:36 AM, Jeffrey Hundstad wrote:

> Hello,
> 
> I confirm that this patch DOES FIX the problem I was seeing with xfs_fsr that caused a hit on the stack-protector.
> 
> Thanks for your hard work!
> 
> Tested-by: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
> 

Thanks for narrowing it down to 1 commit :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
