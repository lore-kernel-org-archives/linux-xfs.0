Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5ED737F62
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 06:37:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D68F0AC001
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 04:37:16 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xScelxZQZWB53L1Q (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 Nov 2015 04:37:15 -0800 (PST)
Date: Thu, 12 Nov 2015 13:37:10 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: xfsprogs install
Message-ID: <20151112123710.GA2585@redhat.com>
References: <CAFf1yNFYh3C9NR8OadL=wXALT3mj58LTVvnE3fypOBXOP_JzoQ@mail.gmail.com>
	<20151111125021.GA28745@redhat.com>
	<CAFf1yNFwY5uANDbTQhQsmdZj=FzOduUDcGGTNG-EnK0P0a+=7w@mail.gmail.com>
	<5643F948.2030703@opensuse.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5643F948.2030703@opensuse.org>
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
To: "Carlos E. R" <carlos.e.r@opensuse.org>
Cc: xfs@oss.sgi.com

On Thu, Nov 12, 2015 at 03:28:24AM +0100, Carlos E. R wrote:
> On 11/12/2015 03:21 AM, rui li wrote:
> >thanks !
> >when i run mkfs.xfs -f /dev/sda2p1 ,the error is no that file or directory
> >acturally /dev/sda2p1  existed
> >could you give me some help?
> >thank you very much
> 
> Why don't you try:
> 
> LANG=POSIX mkfs.xfs -f /dev/sda2p1
> 
> and then post what you get here (it will be in English). Use copy paste,
> don't type nor translate.

+1

although the amount of information you provided isn't enough to say much.

/dev/sda2p1

what kind of device is it? how did you ended up with it? It looks like to be
created by device-mapper / lvm to me, but I can't say just for looking the
device name.

Anyway, what `ls -l /dev/sda2p1` shows to you, maybe it's a broken symbolic link
to somewhere else?

Anyway, just guesses, I don't have any information to say anything else
> 
> -- 
> Cheers/Saludos
> 
>          Carlos E. R. (openSUSE Leap 42.1, test at Minas-Anor)
> 
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
