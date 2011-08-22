Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7MFw1eH075540 for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 10:58:01 -0500
Received: from rcsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 554991DA29D1
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 08:57:59 -0700 (PDT)
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id L4Db860X2B8vGYl6 for
	<xfs@oss.sgi.com>; Mon, 22 Aug 2011 08:57:59 -0700 (PDT)
Message-ID: <4E527C7F.9040807@oracle.com>
Date: Mon, 22 Aug 2011 08:57:51 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1309275199-10801-1-git-send-email-josef@redhat.com>	<4E4F814B.5070202@gmail.com>	<4E4F865B.2010608@gmail.com>	<4E4FD48B.8030101@oracle.com>	<4E4FE1B1.7010601@gmail.com>	<4E51F24F.1050503@oracle.com>
	<CANGUGtCi85Sgrr5R0E8iuN75ubbMX9txZMwnsvp4Wv3Xh+938g@mail.gmail.com>
In-Reply-To: <CANGUGtCi85Sgrr5R0E8iuN75ubbMX9txZMwnsvp4Wv3Xh+938g@mail.gmail.com>
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
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: linux-kernel@vger.kernel.org, Josef Bacik <josef@redhat.com>, xfs@oss.sgi.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org

On 08/22/2011 03:56 AM, Marco Stornelli wrote:
> 2011/8/22 Sunil Mushran<sunil.mushran@oracle.com>:
>> On 08/20/2011 09:32 AM, Marco Stornelli wrote:
>>> Thank. Yes the word "next" is not very clear. I re-read the proposal for
>>> the standard, actually it's seems to me that if we are in the last hole we
>>> should return the file size, if we are not in the last hole than it's ok the
>>> same offset - "....except that
>>> if offset falls beyond the last byte not within a hole, then the file
>>> offset may be set to the file size instead".
>> Any proposal that differentiates between holes is wrong. It should not
>> matter where the hole is.
>>
>> Think of it from the usage-pov.
>>
>> doff = 0;
>> while ((doff = lseek(SEEK_DATA, doff)) != -ENXIO) {
>>     hoff = lseek(SEEK_HOLE, doff);
>>     read_offset = doff;
>>     read_len = hoff -doff;
>>     process();
>>     doff = hoff;
>> }
>>
>> The goal is to make this as efficient as follows. Treating the last
>> hole differently adds more code for no benefit.
>>
> Mmmm.....It seems that Josef has to be clear in this point. However I
> looked for the seek hole test in xfs test suite, but I didn't find
> anything. Btrfs guys, how have you got tested the implementation? What
> do you think about this corner case? Al, what do you think about it?


The following test was used to test the early implementations.
http://oss.oracle.com/~smushran/seek_data/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
