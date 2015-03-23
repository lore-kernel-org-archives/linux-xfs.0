Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D3FB37F4E
	for <xfs@oss.sgi.com>; Mon, 23 Mar 2015 15:01:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6DB5AAC001
	for <xfs@oss.sgi.com>; Mon, 23 Mar 2015 13:01:37 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id sNcdLFldtQ6XHzzV for <xfs@oss.sgi.com>;
	Mon, 23 Mar 2015 13:01:35 -0700 (PDT)
Message-ID: <5510711E.5060304@sandeen.net>
Date: Mon, 23 Mar 2015 15:01:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 03/13 DROP] xfs_db: add crc manipulation commands
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
	<1426624395-8258-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1426624395-8258-4-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

Just drop this patch, it adds xfs_db complexity, and isn't needed as
long as we can write any arbitrary "corrupt" field, including the crc
field of any structure, which my previous patch implements.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
