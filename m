Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A97297F37
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 22:27:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 32DB0AC00B
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 20:27:13 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id mPTQ91zBvm2hDt2E for <xfs@oss.sgi.com>;
	Thu, 21 Jan 2016 20:27:11 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 5AA6E60DDB96
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 22:27:11 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 0/3] xfsprogs: use Q_XGETNEXTQUOTA
Message-ID: <56A1AF9F.80303@sandeen.net>
Date: Thu, 21 Jan 2016 22:27:11 -0600
MIME-Version: 1.0
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

Patch series to make xfs_quota's repquota and quota dump use the new
Q_XGETNEXTQUOTA interface.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
