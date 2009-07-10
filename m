Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6AEYW8D103779 for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 09:34:32 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 16CA8356FDA
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 07:35:08 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id bGYRxp1c8KWivoFG for
	<xfs@oss.sgi.com>; Fri, 10 Jul 2009 07:35:08 -0700 (PDT)
Message-ID: <4A575199.1050903@sandeen.net>
Date: Fri, 10 Jul 2009 09:35:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair stops on "traversing filesystem..."
References: <4A55FAF7.5040908@gmail.com> <4A56D176.9010702@sandeen.net>
	<4A56ED5F.10400@gmail.com>
In-Reply-To: <4A56ED5F.10400@gmail.com>
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
To: Tomek Kruszona <bloodyscarion@gmail.com>
Cc: xfs@oss.sgi.com

Tomek Kruszona wrote:
> Eric Sandeen wrote:
>> No fix for you yet, but it's in cache_node_get(), in the for(;;) loop,
>> and it looks like cache_node_allocate() fails to get a new node and we
>> keep spinning.  I need to look some more at what's going on....
> 
> Hello!
> 
> Is this specific behavior for this particular broken filesystem or is it
> a bug in functions you mentioned? I'm just curious :)


I don't know yet :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
