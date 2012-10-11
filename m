Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9B9DVCh079077 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 04:13:31 -0500
Received: from mail-out4.booking.com (mail-out4.booking.com [91.195.237.21])
	by cuda.sgi.com with ESMTP id Y4ZvLDORu42ipi6X (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 02:15:02 -0700 (PDT)
Date: Thu, 11 Oct 2012 11:15:09 +0200
From: Marcin Deranek <marcin.deranek@booking.com>
Subject: Re: Performance degradation over time
Message-ID: <20121011111509.0a57372a@booking.com>
In-Reply-To: <20121011103352.4ed8bbf5@booking.com>
References: <20121010105142.148519ca@booking.com>
	<50757583.9000901@hardwarefreak.com> <507586B4.6010201@sandeen.net>
	<20121011103352.4ed8bbf5@booking.com>
Mime-Version: 1.0
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
To: Marcin Deranek <marcin.deranek@booking.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, stan@hardwarefreak.com, xfs@oss.sgi.com

On Thu, 11 Oct 2012 10:33:52 +0200
Marcin Deranek <marcin.deranek@booking.com> wrote:

> I guess next step would be to use inode64..

After mounting XFS with inode64 I see performance improvement (open()
now takes ~3ms vs ~15ms previous) although it's still not something I
would expect (~150us.) On Dave's suggestion I will give a shot CentOS
6.x and see if that makes any difference although this needs to be
monitored over longer period of time to reliably tell if that make a
difference.
Regards,

Marcin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
