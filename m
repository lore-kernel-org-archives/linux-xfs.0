Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Jul 2006 08:24:11 -0700 (PDT)
Received: from amanpulo.hosting.qsr.com.ph (amanpulo.hosting.qsr.com.ph [64.34.170.22])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6EFO0DW004209
	for <linux-xfs@oss.sgi.com>; Fri, 14 Jul 2006 08:24:00 -0700
Received: from localhost (localhost [127.0.0.1])
	by amanpulo.hosting.qsr.com.ph (Postfix) with ESMTP id EB7DBC07D9D7
	for <linux-xfs@oss.sgi.com>; Fri, 14 Jul 2006 21:54:52 +0800 (PHT)
Received: from musang.free.net.ph (gusi.leathercollection.ph [202.163.192.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by amanpulo.hosting.qsr.com.ph (Postfix) with ESMTP id A2AA2C0001FF
	for <linux-xfs@oss.sgi.com>; Fri, 14 Jul 2006 21:54:48 +0800 (PHT)
Date: Fri, 14 Jul 2006 21:54:44 +0800
From: Federico Sevilla III <jijo@free.net.ph>
Subject: Request Barriers and Software RAID
Message-ID: <20060714135444.GB3307@free.net.ph>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS Mailing List <linux-xfs@oss.sgi.com>

Hi,

I just upgraded to 2.6.17.4, and with request barriers in XFS enabled by
default, am now discovering that request barriers do not work with my
software RAID 1 configuration. Would anyone know if there's a way of
safely allowing software RAID 1 together with XFS to support request
barriers, so that I can safely enable write caching in my underlying IDE
drives to squeeze out a little bit of additional performance?

Thank you very much.

Cheers!

 --> Jijo

-- 
Federico Vicente C. Sevilla III
Information Technology Consultant
Q Software Research Corporation
Website: http://jijo.free.net.ph
