Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Oct 2007 01:41:25 -0700 (PDT)
Received: from smtpi.seznam.cz (smtpi.seznam.cz [77.75.73.97])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9I8fKuu017864
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2007 01:41:22 -0700
Message-ID: <4717156C.3030308@firma.seznam.cz>
Date: Thu, 18 Oct 2007 10:12:28 +0200
From: Anton A Vorobev <anton.vorobev@firma.seznam.cz>
MIME-Version: 1.0
Subject: Slow seek in kernels >= 2.6.18
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi!

A question. We've got an application that runs about 30-40 minutes. 
After kernel upgrade from 2.6.17 branch, it runs about 3 hours.
I've made tests with the help of bonnie++, it shows that random seek 
operations are about 3 times slower in kernels newer than 2.6.18 in 
comparison with 2.6.17. This difference may be seen only during high 
load of a server. When it is in normal state, parameters are rather the 
same.

We use XFS filesystem. Does any one know may it be because of upgrade of 
XFS driver in kernel? Any ideas?

Thanks a lot.

______________________________________________________________
Anton Vorobev
Programátor
Seznam.cz, a.s. Radlická 608/2 150 00 Praha 5

tel.: +420 234 694 706
fax: +420 234 694 115
anton.vorobev@firma.seznam.cz
http://www.seznam.cz
