Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8909B7F37
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 11:30:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6978B8F8040
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 09:30:16 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id pVtoX5EdeAvdoxfA for <xfs@oss.sgi.com>;
	Mon, 14 Oct 2013 09:30:15 -0700 (PDT)
Message-ID: <525C1C15.7020204@sandeen.net>
Date: Mon, 14 Oct 2013 11:30:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: projid32bit=1 default in xfsprogs-3.2.0
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
To: xfs-oss <xfs@oss.sgi.com>, =?UTF-8?B?QXJrYWRpdXN6IE1pxZtraWV3aWN6?= <arekm@maven.pl>

The commit:

f3edb66a mkfs.xfs: validate options for CRCs up front.

unintentionally (?) defaulted to projid32bit=1 for all filesystems
at mkfs time.

Support for 32 bit project IDs has been present since kernel v2.6.37.

Is everybody ok with making this change for 3.2.0?  Speak now or
forever hold your peace, as they say.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
