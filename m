Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7MI2vMv080802 for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 13:02:57 -0500
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D3B9190FB9C
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 11:02:42 -0700 (PDT)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id xIm4FMAVFLDeGvGm
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 11:02:42 -0700 (PDT)
Received: by wyg36 with SMTP id 36so4365334wyg.26
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 11:02:41 -0700 (PDT)
Message-ID: <4E52984F.8050702@gmail.com>
Date: Mon, 22 Aug 2011 19:56:31 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1309275199-10801-1-git-send-email-josef@redhat.com>	<4E4F814B.5070202@gmail.com>	<4E4F865B.2010608@gmail.com>	<4E4FD48B.8030101@oracle.com>	<4E4FE1B1.7010601@gmail.com>	<4E51F24F.1050503@oracle.com>
	<CANGUGtCi85Sgrr5R0E8iuN75ubbMX9txZMwnsvp4Wv3Xh+938g@mail.gmail.com>
	<4E527C7F.9040807@oracle.com>
In-Reply-To: <4E527C7F.9040807@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: linux-kernel@vger.kernel.org, Josef Bacik <josef@redhat.com>, xfs@oss.sgi.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org

Il 22/08/2011 17:57, Sunil Mushran ha scritto:
>>> Any proposal that differentiates between holes is wrong. It should not
>>> matter where the hole is.
>>>
>>> Think of it from the usage-pov.
>>>
>>> doff = 0;
>>> while ((doff = lseek(SEEK_DATA, doff)) != -ENXIO) {
>>> hoff = lseek(SEEK_HOLE, doff);
>>> read_offset = doff;
>>> read_len = hoff -doff;
>>> process();
>>> doff = hoff;
>>> }
>>>
>>> The goal is to make this as efficient as follows. Treating the last
>>> hole differently adds more code for no benefit.
>>>
>> Mmmm.....It seems that Josef has to be clear in this point. However I
>> looked for the seek hole test in xfs test suite, but I didn't find
>> anything. Btrfs guys, how have you got tested the implementation? What
>> do you think about this corner case? Al, what do you think about it?
>
>
> The following test was used to test the early implementations.
> http://oss.oracle.com/~smushran/seek_data/
>

Thank you very much!! I found another point. Your test fails with my 
implementation because here 
(http://www.austingroupbugs.net/view.php?id=415) says: "If whence is 
SEEK_DATA, the file offset shall be set to the smallest location of a 
byte not within a hole and not less than offset. It shall be an error if 
no such byte exists." So in this case I return ENXIO but the test 
expects another value. I have to say that there is a bit of confusion 
about the real behavior of this new feature :)

Marco

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
