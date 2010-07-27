Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6RJuSiq206314 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 14:56:28 -0500
Received: from CGYSNEX002.encana.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A80F12BD013
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 13:06:52 -0700 (PDT)
Received: from CGYSNEX002.encana.com (cgysnex002.encana.com [142.56.87.69]) by
	cuda.sgi.com with ESMTP id 9CFLQOyftE2DbGTP for
	<xfs@oss.sgi.com>; Tue, 27 Jul 2010 13:06:52 -0700 (PDT)
Received: from CGYEX202.encana.com (unverified) by CGYSNEX002.encana.com
	(Clearswift SMTPRS 5.3.2) with ESMTP id
	<T97209c31888e38574515b0@CGYSNEX002.encana.com> for <xfs@oss.sgi.com>;
	Tue, 27 Jul 2010 13:59:28 -0600
Received: from CGYEX710.encana.com (unverified) by CGYEX202.encana.com
	(Clearswift SMTPRS 5.3.2) with ESMTP id
	<T97209c31dd8e38c91316c8@CGYEX202.encana.com> for <xfs@oss.sgi.com>;
	Tue, 27 Jul 2010 13:59:28 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: High latencies writing to a memory mapped file
Date: Tue, 27 Jul 2010 13:59:28 -0600
Message-ID: <F57F2AD357626644AF76410876025D75529604@CGYEX705.encana.com>
In-Reply-To: <20100727144914.GA29349@citd.de>
References: <20100722144706.GA2840@BohrerMBP.rgmadvisors.com><20100727092452.GA23307@citd.de><4C4EDEFD.7000401@hardwarefreak.com>
	<20100727144914.GA29349@citd.de>
From: "Kinzel, David" <David.Kinzel@encana.com>
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
To: xfs@oss.sgi.com

>> Matthias Schniedermeyer put forth on 7/27/2010 4:24 AM:
>> 
>> > We have a linux-computer with samba to act as a fileserver 
>for a few 
>> > Windows-Clients and ever since kernel 2.6.26 (Never 
>happend with 2.6.25) 
>> > the server randomly "hangs" for a few seconds (Which is more of a 
>> > problem that drives people crazy).
>> 

The server hangs, or the connections to samba do? I've found that samba
is given a ridiculously low IO priority so that any IO on the server
will pretty much cause it to stall -- be it updating locate, a backup
job, etc. 

This email communication and any files transmitted with it may contain confidential and or proprietary information and is provided for the use of the intended recipient only.  Any review, retransmission or dissemination of this information by anyone other than the intended recipient is prohibited.  If you receive this email in error, please contact the sender and delete this communication and any copies immediately.  Thank you.
http://www.encana.com



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
