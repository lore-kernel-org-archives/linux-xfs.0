Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 10 Nov 2007 22:18:46 -0800 (PST)
Received: from mail9.dslextreme.com (mail9.dslextreme.com [66.51.199.94])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAB6Iebp023815
	for <xfs@oss.sgi.com>; Sat, 10 Nov 2007 22:18:42 -0800
Message-ID: <4736987E.4000208@danbala.com>
Date: Sat, 10 Nov 2007 21:51:58 -0800
From: Dirck Blaskey <listtarget2@danbala.com>
MIME-Version: 1.0
Subject: files getting truncated on xfs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Although there was a truncation bug listed as introduced in 2.6.21 and 
fixed before 2.6.22,

I had a number of truncations occur with Ubuntu Gutsy Gibbon (kernel 
2.6.22) AMD64 build
using XFS on RAID 1 partition, so apparently it's not fixed.  This 
looked very much like
the bug described previously - a number of files truncated to block 
boundaries on restart.

I've dropped XFS for Ext3 and AMD64 for I386 in the hopes of finding 
some stability.

best regards,
d
