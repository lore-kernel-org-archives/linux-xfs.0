Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 763877F3F
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 14:32:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 31CFD304059
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 12:32:22 -0800 (PST)
Received: from na01-bl2-obe.outbound.protection.outlook.com
	(mail-bl2lp0204.outbound.protection.outlook.com
	[207.46.163.204]) by cuda.sgi.com with ESMTP id
	7uQJekfigJJPnjMA (version=TLSv1 cipher=AES128-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Jan 2014 12:32:21 -0800 (PST)
From: Muralitharan Perumal <Muralitharan.Perumal@pace.com>
Subject: RE: kernel 2.6.22 pdflush consumes ~90% cpu
Date: Mon, 13 Jan 2014 20:32:12 +0000
Message-ID: <36564b8f1d004d8584e5622863f6dd69@CO2PR05MB796.namprd05.prod.outlook.com>
References: <52D3FF2E.3010901@pace.com>
In-Reply-To: <52D3FF2E.3010901@pace.com>
Content-Language: en-US
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Dave,

Is this related to log buffer size when formatting and mounting as I am just using the default 32KB buffer size?

Any pointers will be helpful.


-----Original Message-----
From: xfs-bounces@oss.sgi.com [mailto:xfs-bounces@oss.sgi.com] On Behalf Of Muralitharan Perumal
Sent: 13 January 2014 14:59
To: xfs@oss.sgi.com
Subject: kernel 2.6.22 pdflush consumes ~90% cpu

Hi,

I am currently working on an embedded platform involving XFS as the preferred fs. Earlier, ext3 was used but now replaced with XFS. The unit is working fine with ext3 but after replacing with XFS, I am seeing a few issues:

a) Occassionally I am getting the following error when we write files to the fs:

attempt to access beyond end of device
sda1: rw=0, want=10487141907480064, limit=9766912
I/O error in filesystem ("sda1") meta-data dev sda1 block 0x254200001abdf8       ("xfs_trans_read_buf") error 5 buf count 4096
attempt to access beyond end of device
sda1: rw=0, want=10487141907480064, limit=9766912
I/O error in filesystem ("sda1") meta-data dev sda1 block 0x254200001abdf8       ("xfs_trans_read_buf") error 5 buf count 4096

b) After running for about 20 to 25 minutes, the pdflush consumes about 90% cpu and stuck there in D state:

Is there any similar issue seen with kernel 2.6.22? Am I missing any XFS patches that could fix this?

Any pointers would be helpful.

Thanks,
Murali


IMPORTANT NOTICE - this e-mail and any attachments hereto are strictly confidential and intended solely for the addressee. If you are not the intended recipient, please notify the sender to report the error and delete this communication immediately. You must not disclose, forward or copy this e-mail or any attachments hereto without the prior consent of the sender.
IMPORTANT NOTICE - this e-mail and any attachments hereto are strictly confidential and intended solely for the addressee. If you are not the intended recipient, please notify the sender to report the error and delete this communication immediately. You must not disclose, forward or copy this e-mail or any attachments hereto without the prior consent of the sender.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
