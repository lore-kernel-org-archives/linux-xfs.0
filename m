Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBTD8k0s006095 for <xfs@oss.sgi.com>; Thu, 29 Dec 2011 07:08:46 -0600
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
	[209.85.212.181]) by cuda.sgi.com with ESMTP id
	T3KDwcsMf9W6qeia for <xfs@oss.sgi.com>;
	Thu, 29 Dec 2011 05:08:44 -0800 (PST)
Received: by wibhq2 with SMTP id hq2so7506155wib.26
	for <xfs@oss.sgi.com>; Thu, 29 Dec 2011 05:08:44 -0800 (PST)
Message-ID: <4efc665b.d139e30a.2f32.fffff97a@mx.google.com>
Date: Thu, 29 Dec 2011 13:10:49 +0000
From: "amit.sahrawat83@gmail.com" <amit.sahrawat83@gmail.com>
Subject: Preallocation with direct IO?
MIME-Version: 1.0
Reply-To: amit.sahrawat83@gmail.com
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
To: "hch@infradead.org" <hch@infradead.org>, "david@fromorbit.com" <david@fromorbit.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi,
I am using a test setup which is doing write using multiple threads using direct IO. The buffer size which is used to write is 512KB.
After continously running this for long duration - i observe that number of extents in each file is getting huge(2K..4K..). I observed that each extent is of 512KB(aligned to write buffer size). I wish to have low number of extents(i.e, reduce fragmentation)... In case of buffered IO- preallocation works good alongwith the mount option 'allocsize'. Is there anything which can be done for Direct IO?
Please advice for reducing fragmentation with direct IO.
Thanks & Regards,
Amit Sahrawat
Sent from my Nokia phone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
