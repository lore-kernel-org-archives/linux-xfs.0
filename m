Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Aug 2006 14:40:58 -0700 (PDT)
Received: from service.eng.exegy.net (68-191-203-42.static.stls.mo.charter.com [68.191.203.42])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k73LehDW014918
	for <xfs@oss.sgi.com>; Thu, 3 Aug 2006 14:40:43 -0700
Message-ID: <44D26D3E.5010708@exegy.com>
Date: Thu, 03 Aug 2006 16:40:14 -0500
From: Dave Lloyd <dlloyd@exegy.com>
MIME-Version: 1.0
Subject: Re: Concurrent mount of XFS over SAN
References: <20060803143301.51757.qmail@web31704.mail.mud.yahoo.com>
In-Reply-To: <20060803143301.51757.qmail@web31704.mail.mud.yahoo.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Heilige Gheist <hgheist@yahoo.com>
Cc: xfs@oss.sgi.com

Heilige Gheist wrote:
 > Is there a way to prevent and/or detect concurrent mount of same XFS
 > SAN-based partition from several nodes?
 > I had to fsck a filesystem losing some data after two nodes happily
 > mounted a filesystem from same SAN-based partition at the same time and
 > wrote into it.
 > Thanks!
 >
 > --alan
 >
 > __________________________________________________
 > Do You Yahoo!?
 > Tired of spam?  Yahoo! Mail has the best spam protection around
 > http://mail.yahoo.com
 >
 >

I think that the generally accepted way is to zone at the switch or the
storage array.

-- 
Dave Lloyd
Test Engineer, Exegy, Inc.
314.450.5342
dlloyd@exegy.com
