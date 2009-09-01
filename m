Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n81HtAQA197497 for <xfs@oss.sgi.com>; Tue, 1 Sep 2009 12:55:20 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 317F315A10C5
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2009 10:55:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lsfdAjSuNmlgl5F0 for
	<xfs@oss.sgi.com>; Tue, 01 Sep 2009 10:55:39 -0700 (PDT)
Message-ID: <4A9D600B.4020405@sandeen.net>
Date: Tue, 01 Sep 2009 12:55:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs compat_ioctl?
References: <4A9B759B.7020401@msgid.tls.msk.ru>	<20090831123010.GA2368@infradead.org>	<64bb37e0908311114t4a3cefc3v8ea5092e1558c578@mail.gmail.com>	<20090831182754.GA3620@infradead.org>
	<64bb37e0909011000l78a0aef0wf4c53252c14af75e@mail.gmail.com>
In-Reply-To: <64bb37e0909011000l78a0aef0wf4c53252c14af75e@mail.gmail.com>
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
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Michael Tokarev <mjt@tls.msk.ru>, Linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Torsten Kaiser wrote:
> On Mon, Aug 31, 2009 at 8:27 PM, Christoph Hellwig<hch@infradead.org> wrote:
>> I think you are right, the constant used is incorrect.  Does the small
>> patch below fix it for you?
> 
> Yes, after adding this patch, xfs_fsr works.

Crud, sorry about that.  I swear I ran 32-bit xfstests under a 64-bit
kernel, but I think we were lacking in fsr coverage....

-Eric

>> Index: linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c
>> ===================================================================
>> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl32.c       2009-08-31 15:25:06.093044591 -0300
>> +++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c    2009-08-31 15:25:10.856544216 -0300
>> @@ -619,7 +619,7 @@ xfs_file_compat_ioctl(
>>        case XFS_IOC_GETVERSION_32:
>>                cmd = _NATIVE_IOC(cmd, long);
>>                return xfs_file_ioctl(filp, cmd, p);
>> -       case XFS_IOC_SWAPEXT: {
>> +       case XFS_IOC_SWAPEXT_32: {
>>                struct xfs_swapext        sxp;
>>                struct compat_xfs_swapext __user *sxu = arg;
>>
>>
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
