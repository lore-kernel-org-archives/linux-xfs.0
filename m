Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C575B29DF8
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 22:06:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A4298304051
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 20:06:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 22O2BviZvFTUGDHm for
	<xfs@oss.sgi.com>; Thu, 09 May 2013 20:06:00 -0700 (PDT)
Message-ID: <518C6414.20800@redhat.com>
Date: Thu, 09 May 2013 22:05:56 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: regression test for ext4 resize with non-extent
	files
References: <518C1D08.4080309@redhat.com>
	<CA+dCu8_DtrqMy97u9NfHwCC8_-z9uSrF1oR3B=ej15gL6C=W+Q@mail.gmail.com>
In-Reply-To: <CA+dCu8_DtrqMy97u9NfHwCC8_-z9uSrF1oR3B=ej15gL6C=W+Q@mail.gmail.com>
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
To: guaneryu@gmail.com
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 5/9/13 10:03 PM, Eryu Guan wrote:
> On Fri, May 10, 2013 at 6:02 AM, Eric Sandeen <sandeen@redhat.com <mailto:sandeen@redhat.com>> wrote:
> 

...

>     index 53af708..4c3e2f4 100644
>     --- a/tests/ext4/group
>     +++ b/tests/ext4/group
>     @@ -9,3 +9,4 @@
>      303 aio dangerous ioctl rw stress
>      304 aio dangerous ioctl rw stress
>      305 auto
>     +306 dangerous rw resize quick
> 
> 
> I'm wondering why it's not in auto group :)


because I forgot about auto! :)

But it's also somewhat dangerous; it could oops or hang, so perhaps
auto is not a good idea.

-Eric


> Otherwise patch looks good to me.
> 
> Eryu Guan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
