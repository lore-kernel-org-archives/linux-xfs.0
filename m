Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Feb 2008 03:44:31 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1JBiP1G030732
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 03:44:26 -0800
Received: from smtp-out002.kontent.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 147435F0642
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 03:44:50 -0800 (PST)
Received: from smtp-out002.kontent.com (smtp-out002.kontent.com [81.88.40.216]) by cuda.sgi.com with ESMTP id fY8zNrBOsIGZcaj2 for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 03:44:50 -0800 (PST)
Message-ID: <47BAC139.3000109@theendofthetunnel.de>
Date: Tue, 19 Feb 2008 12:44:57 +0100
From: Hannes Dorbath <light@theendofthetunnel.de>
MIME-Version: 1.0
Subject: Re: tuning, many small files, small blocksize
References: <e03b90ae0802152101t2bfa4644kcca5d6329239f9ff@mail.gmail.com>	<47BA10EC.3090004@tlinx.org>	<20080218235103.GW155407@sgi.com>	<47BA2AFD.2060409@tlinx.org>	<20080219024924.GB155407@sgi.com>	<e03b90ae0802182058h7a1535c6w749eb46cbe434ef2@mail.gmail.com> <18362.37642.577718.529415@tree.ty.sabi.co.UK>
In-Reply-To: <18362.37642.577718.529415@tree.ty.sabi.co.UK>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Grandi <pg_xf2@xfs2.for.sabi.co.UK>
Cc: Linux XFS <xfs@oss.sgi.com>

> That sounds like a good use for a LDAP database, but using
> Berkeley DB directly may be best. One could also do a FUSE module
> or a special purpose NFS server that presents a Berkeley DB as a
> filesystem, but then we would be getting rather close to ReiserFS.

During testing of HA clusters some time ago I found BDB to always be the 
first thing to break. It seems to have very poor recovery and seems not 
fine with neither file systems snapshots nor power failures. 
Nevertheless it's claimed ACID conform. I don't know -- from my 
experience I wouldn't even put my address book on it.

Personally I ended up doing this for OpenLDAP and never looked back: 
http://www.samse.fr/GPL/ldap_pg/HOWTO/x12.html


-- 
Best regards,
Hannes Dorbath
