Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7NHoU2w206423 for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 12:50:30 -0500
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 000F71394868
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 10:53:09 -0700 (PDT)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id ijrM8Y62P04AuXDA
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 10:53:09 -0700 (PDT)
Received: by wyg36 with SMTP id 36so299271wyg.26
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 10:50:27 -0700 (PDT)
Message-ID: <4E53E6F4.1040006@gmail.com>
Date: Tue, 23 Aug 2011 19:44:20 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1309275199-10801-1-git-send-email-josef@redhat.com>	<4E4F814B.5070202@gmail.com>	<4E4F865B.2010608@gmail.com>	<4E4FD48B.8030101@oracle.com>	<4E4FE1B1.7010601@gmail.com>	<4E51F24F.1050503@oracle.com>
	<CANGUGtCi85Sgrr5R0E8iuN75ubbMX9txZMwnsvp4Wv3Xh+938g@mail.gmail.com>
	<4E527C7F.9040807@oracle.com> <4E52984F.8050702@gmail.com>
	<4E52C890.1060600@oracle.com>
In-Reply-To: <4E52C890.1060600@oracle.com>
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

Il 22/08/2011 23:22, Sunil Mushran ha scritto:
> On 08/22/2011 10:56 AM, Marco Stornelli wrote:
>> Il 22/08/2011 17:57, Sunil Mushran ha scritto:
>>>
>>> The following test was used to test the early implementations.
>>> http://oss.oracle.com/~smushran/seek_data/
>>>
>>
>> Thank you very much!! I found another point. Your test fails with my
>> implementation because here
>> (http://www.austingroupbugs.net/view.php?id=415) says: "If whence is
>> SEEK_DATA, the file offset shall be set to the smallest location of a
>> byte not within a hole and not less than offset. It shall be an error
>> if no such byte exists." So in this case I return ENXIO but the test
>> expects another value. I have to say that there is a bit of confusion
>> about the real behavior of this new feature :)
>>
>
> That's test 5.10, 5.12, 5.14. And it expects -ENXIO.
>
> Which test is failing for you?
>

Sorry, I was reading the results in a wrong way.

Marco

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
