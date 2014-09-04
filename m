Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8702D7F54
	for <xfs@oss.sgi.com>; Thu,  4 Sep 2014 05:14:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 589B48F8040
	for <xfs@oss.sgi.com>; Thu,  4 Sep 2014 03:14:50 -0700 (PDT)
Received: from mail-pd0-f169.google.com (mail-pd0-f169.google.com
	[209.85.192.169]) by cuda.sgi.com with ESMTP id
	sJGd8rQm1PKHWE5u (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Sep 2014 03:14:49 -0700 (PDT)
Received: by mail-pd0-f169.google.com with SMTP id y10so3879071pdj.28
	for <xfs@oss.sgi.com>; Thu, 04 Sep 2014 03:14:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACyNnZNUMdv=EUAaYmW69X+0yB7qmsVA3bC=ChJiKb_X4WCt-w@mail.gmail.com>
References: <CACyNnZNUMdv=EUAaYmW69X+0yB7qmsVA3bC=ChJiKb_X4WCt-w@mail.gmail.com>
Date: Thu, 4 Sep 2014 12:14:39 +0200
Message-ID: <CACyNnZNtuLH4+653z_BtaFVy9fY=YP2QAYM=53MtdRa_jmbrBg@mail.gmail.com>
Subject: Re: Ghost items in the end of a dir listing
From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
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
To: xfs@oss.sgi.com

Hello,

No ideas about this? =(

Any kind of tip would be really appreciated =)

thanks,

Felipe Monteiro de Carvalho

On Wed, Aug 27, 2014 at 12:20 PM, Felipe Monteiro de Carvalho
<felipemonteiro.carvalho@gmail.com> wrote:
> Hello,
>
> I am writing a program that reads XFS partitions and I am having
> trouble with some dir listings. In some directories in the block that
> starts with XD2B there is first the list of all directory items, which
> I read without problems, and then there is a free item, for example:
>
>   xfs_dir2_data_unused
>     freetag -> XFS_DIR2_DATA_FREE_TAG */
>     length -> 9A0
>     tag -> zero
>
> But after this free item there is still room in the block, so my
> program will try to read the next item. I cannot stop the reading
> because it is possible to have valid items, then a free item and then
> more valid items.
>
> The next item start might be something like:
>
> 00 00 00 2E 00 00 00 02 16
>
> So it is not a free item, as it doesn't start with FF = XFS_DIR2_DATA_FREE_TAG
> But it isn't valid either, as its name is a bunch of trash =(
>
> So my questions are:
> 1> What are those ghost items in the end of the block?
> 2> Which criteria should be utilized to differentiate them from valid
> items? I tried some guesses but nothing really works so far...
>
> Here are screenshots of the actual data involved, here showing the
> item with XFS_DIR2_DATA_FREE_TAG:
>
> http://magnifier.sourceforge.net/temp/xfs/xfs_dir_listing_XD2B_FREE_item.png
>
> And here showing the area in the end of the block with wierd items:
>
> http://magnifier.sourceforge.net/temp/xfs/xfs_dir_listing_XD2B_after_FREE.png
>
> thanks for any tips =)
> --
> Felipe Monteiro de Carvalho



-- 
Felipe Monteiro de Carvalho

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
