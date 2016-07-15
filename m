Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AD8467CA3
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2016 04:47:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 72E108F8037
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2016 02:46:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DcWDvJtYxXH52GDT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Jul 2016 02:46:54 -0700 (PDT)
Date: Fri, 15 Jul 2016 11:46:47 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: mkfs.xfs -d su=XXX,sw=YYY and future volume resize
Message-ID: <20160715094647.GD3608@redhat.com>
References: <CACNifpVsOMKQyshHk8B7WrmsbGAN_fOz6qpHLBTc_N=K1xY0Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACNifpVsOMKQyshHk8B7WrmsbGAN_fOz6qpHLBTc_N=K1xY0Dw@mail.gmail.com>
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
To: Marcin Sura <mailing-lists@sura.pl>
Cc: xfs@oss.sgi.com

On Thu, Jul 14, 2016 at 10:19:02PM +0200, Marcin Sura wrote:
>    Hi,
>    When I create filesystem I can specify su and sw paramteres which match
>    underlying storage device.
>    So for example, If I have raid 6 volume made of 6 + 2 disks with stripe
>    size of 256k I create xfs with:
>    mkfs.xfs -d su=256k,sw=6 <disk>
>    But what if I will extend original volume by 2 disks. sw will 8. Will
>    be there a performance panelty compared to filesystem created from
>    scratch with correct sw parameter?
>    BR
>    Marcin

Complementing Dave's answer, you can also mount the filesystem with new
alignment configuration.

You can use: sunit=value and swidth=value for mounting the FS with the new
settings. man xfs for more info.

Cheers

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
