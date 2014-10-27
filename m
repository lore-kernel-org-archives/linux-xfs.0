Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A883B7F63
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 13:50:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 377FDAC008
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 11:50:08 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id gWcdQmXERtLOJMkx for <xfs@oss.sgi.com>;
	Mon, 27 Oct 2014 11:50:07 -0700 (PDT)
Message-ID: <544E93DD.2010706@sandeen.net>
Date: Mon, 27 Oct 2014 13:50:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: enable sparse checking
References: <54498F4A.9030207@redhat.com>
In-Reply-To: <54498F4A.9030207@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 10/23/14 6:29 PM, Eric Sandeen wrote:
> Enable "make C=1" or "make C=2" to do sparse checking.
> Blatantly ripped off from djwong's patch in e2fsprogs to
> do the same.
> 
> Note, this requires unreleased sparse after v0.5, which
> enables the CHAR_BIT definition; otherwise it chokes.

Ok, NAK to this one I guess, hch has sufficiently pointed out
that I don't quite know what I'm doing here ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
