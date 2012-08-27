Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7R7Ciup011310 for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 02:12:44 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	jQLi7lVxw4XONU7e (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 27 Aug 2012 00:13:33 -0700 (PDT)
Received: by obbwd18 with SMTP id wd18so5071747obb.26
	for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 00:13:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1208270952390.8166@mail.vlasiu.net>
References: <CAAxjCEwdYbcDoUvcAV1n8281HCCvrCvReaG2oM5+h+WV5yDZvA@mail.gmail.com>
	<1104CDC2-47D2-40CF-8294-A17E33125D54@sandeen.net>
	<CAAxjCExx8LB3PyMUR8T215hMYps17D+Lvg4C0aOwLwD=d-NOMQ@mail.gmail.com>
	<alpine.LRH.2.02.1208270952390.8166@mail.vlasiu.net>
Date: Mon, 27 Aug 2012 09:13:33 +0200
Message-ID: <CAAxjCEynRoS3AfYer=is725XR+kZEwe_SPxt_iDTJNRMo2UxOA@mail.gmail.com>
Subject: Re: umount doesn't seem to really unmount
From: Stefan Ring <stefanrin@gmail.com>
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
To: Gabriel VLASIU <gabriel@vlasiu.net>
Cc: xfs@oss.sgi.com

>> $ sudo service mysqld start
> Does not work for me. It must be something else.

It seems to happen with any service that has PrivateTmp set:

$ grep PrivateTmp /usr/lib/systemd/system/*.service
/usr/lib/systemd/system/colord-sane.service:PrivateTmp=yes
/usr/lib/systemd/system/colord.service:PrivateTmp=yes
/usr/lib/systemd/system/cups.service:PrivateTmp=true
/usr/lib/systemd/system/httpd-event.service:PrivateTmp=true
/usr/lib/systemd/system/httpd.service:PrivateTmp=true
/usr/lib/systemd/system/httpd-worker.service:PrivateTmp=true
/usr/lib/systemd/system/mysqld.service:PrivateTmp=true
/usr/lib/systemd/system/openvpn@.service:PrivateTmp=true

I guess that the XFS filesystem must be mounted at the time the
service gets started for this to happen. In that case, the service
seems to hold a hidden reference to XFS which get released when the
service is stopped.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
