Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o12MPt7P195633 for <xfs@oss.sgi.com>; Tue, 2 Feb 2010 16:25:56 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B54B51C9AF24
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2010 14:27:04 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1XUdq4pWXOeklnUm for
	<xfs@oss.sgi.com>; Tue, 02 Feb 2010 14:27:04 -0800 (PST)
Message-ID: <4B68A68C.6030001@gmail.com>
Date: Tue, 02 Feb 2010 23:26:20 +0100
From: Edward Shishkin <edward.shishkin@gmail.com>
MIME-Version: 1.0
Subject: Re: [patch 0/7] per-bdi flushing model improvements. reiser4
References: <201002020255.46920.edward.shishkin@gmail.com>	
	<20100202081728.GA2384@infradead.org>
	<4B6843E9.9070600@gmail.com>	 <20100202194208.GD5733@kernel.dk>
	<5e2ec5ac1002021345g569c743dtc5ccf77cde6738ae@mail.gmail.com>
In-Reply-To: <5e2ec5ac1002021345g569c743dtc5ccf77cde6738ae@mail.gmail.com>
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
To: Ronni Holm-Nielsen <theronni@gmail.com>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>, Johannes Buchner <buchner.johannes@gmx.at>, ReiserFS Development List <reiserfs-devel@vger.kernel.org>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com

Hello everyone.

The patches 1-3 are reverses for the following -mm stuff:

http://userweb.kernel.org/~akpm/mmotm/broken-out/reiser4-fixed-null-pointer-dereference.patch
http://userweb.kernel.org/~akpm/mmotm/broken-out/reiser4-generic_sync_sb_inodes-doesnt-exist-anymore.patch
http://userweb.kernel.org/~akpm/mmotm/broken-out/reiser4-vfs-add-super_operationssync_inodes-2.patch

This is incorrect attempts to adjust reiser4 to the new per-bdi flushing 
model.
The authors are cc-ed,
any comments, suggestions are welcome.

Thanks,
Edward.


Ronni Holm-Nielsen wrote:
> To clarify (being a ReiserFS subscriber):
>
> patch 0, 4-6 sent to Andrew, ReiserFS, linux-fsdevel, linux-kernel, xfs,
> jens.axboe
> patch 1-3, 7 sent to Andrew, ReiserFS
>
> - Ronni
>
> On Tue, Feb 2, 2010 at 11:42 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
>
>   
>> On Tue, Feb 02 2010, Edward Shishkin wrote:
>>     
>>> Christoph Hellwig wrote:
>>>       
>>>> I got this introduction twice, but patches 1-3 didn't make it to any of
>>>> the lists.
>>>>
>>>>
>>>>
>>>>         
>>> done
>>>       
>> Where?
>>
>> --
>> Jens Axboe
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe reiserfs-devel"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>     
>
>
>
>   

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
