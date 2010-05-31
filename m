Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4VGUAYY181565 for <xfs@oss.sgi.com>; Mon, 31 May 2010 11:30:10 -0500
Received: from mailgate.ics.forth.gr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69790387615
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 09:32:35 -0700 (PDT)
Received: from mailgate.ics.forth.gr (mailgate.ics.forth.gr [139.91.1.2]) by
	cuda.sgi.com with ESMTP id eD6X3VEaaka35IzC for
	<xfs@oss.sgi.com>; Mon, 31 May 2010 09:32:35 -0700 (PDT)
Received: from av1.ics.forth.gr ([139.91.157.71])
	by mailgate.ics.forth.gr (8.14.3/ICS-FORTH/V10-1.8-GATE) with ESMTP id
	o4VGW1HT002000
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 19:32:34 +0300 (EEST)
Received: from [139.91.92.13] ([139.91.92.13]) (authenticated bits=0)
	by enigma.ics.forth.gr (8.14.3//ICS-FORTH/V10.3.0C-EXTNULL-SSL-SASL)
	with ESMTP id o4VGW1eJ001676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 19:32:01 +0300
Message-ID: <4C03E46B.9040407@ics.forth.gr>
Date: Mon, 31 May 2010 19:31:39 +0300
From: Yannis Klonatos <klonatos@ics.forth.gr>
MIME-Version: 1.0
Subject: xfs_buf and buffercache/pagecache connection
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

         I was looking to add a kernel hook to my system in order to 
monitor buffer-cache hit and misses. Initially I was
planning to add my modifications to the __getblk(). However, i noticed 
that XFS does not directly use the buffer-cache
for its pages but it seems to implement its own buffer.
         What I am now looking for is 1) the place where XFS checks 
whether a page exists in its buffer or not and 2)
what are the possible interactions between xfs_buf and the Linux kernel 
buffer-cache.
         I would appreciate any information regarding the above issues.

Thanks in advance,
Yannis Klonatos





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
