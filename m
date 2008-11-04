Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Nov 2008 01:51:13 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA49owEb022173
	for <linux-xfs@oss.sgi.com>; Tue, 4 Nov 2008 01:50:59 -0800
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B8A5F5782DF
	for <linux-xfs@oss.sgi.com>; Tue,  4 Nov 2008 01:51:01 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com with ESMTP id nXGFl6TDaOJ3iNbV for <linux-xfs@oss.sgi.com>; Tue, 04 Nov 2008 01:51:01 -0800 (PST)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mA49p1nu030727
	for <linux-xfs@oss.sgi.com>; Tue, 4 Nov 2008 04:51:01 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA49p0ni030400
	for <linux-xfs@oss.sgi.com>; Tue, 4 Nov 2008 04:51:00 -0500
Received: from localhost.localdomain (dhcp-lab-173.englab.brq.redhat.com [10.34.33.173])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id mA49oxNo012601
	for <linux-xfs@oss.sgi.com>; Tue, 4 Nov 2008 04:50:59 -0500
Message-ID: <49101B02.60004@redhat.com>
Date: Tue, 04 Nov 2008 10:50:58 +0100
From: Ales Zelinka <azelinka@redhat.com>
MIME-Version: 1.0
Subject: [RFE] --reference option for setfattr
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hello,

currently when I want to copy all extended attributes from one file to 
another, I have to use ugly command like this:

getfattr --dump -m '-' /etc/samba/smb.conf |sed 's;file: 
etc/samba/smb.conf;file: /tmp/smb.conf;'| setfattr --restore=-

Would you please implement --reference=some_file option that will read 
all extended attributes set on some_file and set them on pathname?

The previous use case would then look like this:

setfattr --reference=/etc/samba/smb.conf /tmp/smb.conf

Other commands from file-attributes-manipulation familly already have 
parameter like this (chmod, chown, chcon,...)

Thanks

Ales Zelinka
