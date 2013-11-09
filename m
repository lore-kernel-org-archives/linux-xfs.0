Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CB67229E10
	for <xfs@oss.sgi.com>; Sat,  9 Nov 2013 05:44:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ABDFA304053
	for <xfs@oss.sgi.com>; Sat,  9 Nov 2013 03:44:43 -0800 (PST)
Received: from mail-ie0-f179.google.com (mail-ie0-f179.google.com
	[209.85.223.179]) by cuda.sgi.com with ESMTP id
	NXo35aFHzc4IuWXt (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 09 Nov 2013 03:44:42 -0800 (PST)
Received: by mail-ie0-f179.google.com with SMTP id u16so1772180iet.10
	for <xfs@oss.sgi.com>; Sat, 09 Nov 2013 03:44:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <527E0AE6.6010202@oracle.com>
References: <CAD+1EGPf=ddMP4vdDxkkWnJH2q9fCSa5uTT-eRAxYLAEtPrLwg@mail.gmail.com>
	<527DEB69.8050502@oracle.com>
	<CAD+1EGNxBnSSXGqi7edgdu7uquOOiPWVd7v-avRrJxzKhSY_UQ@mail.gmail.com>
	<527E0AE6.6010202@oracle.com>
Date: Sat, 9 Nov 2013 19:44:42 +0800
Message-ID: <CAD+1EGPRJhiYvLyZnPyYktBGSScB0MzFj1G-ADP7pVtg-x527Q@mail.gmail.com>
Subject: Re: How to feel the real time feature of XFS from userspace
From: harryxiyou <harryxiyou@gmail.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Zhi Yong Wu <zwu.kernel@gmail.com>, xfs@oss.sgi.com

On Sat, Nov 9, 2013 at 6:13 PM, Jeff Liu <jeff.liu@oracle.com> wrote:
> Hi Harry,

Hi Jeff,

> As this inode has been marked to realtime, the subsequent write via
> directIO will allocate
> extents via it's specific allocation algorithm rather than the general
> approach, and the
> extent length is specified with fsx_extsize.
> AFAICS, the realtime file data will be allocated on realtime volume
> while the metadata will
> still be allocated from the data volume.
>

I see. However, I think current real-time feature of XFS should be enhanced
and could write/read specific data during specific time interval. I have no
exact ideas about this. I would do if I could. Anyway, thanks for your replies.

-- 
Thanks
Weiwei  Jia (Harry Wei)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
