Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AE0837F8B
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 11:14:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 801728F8052
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 09:14:41 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id LHjzHjph6D5Tujes for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2015 09:14:40 -0700 (PDT)
Subject: Re: xfs corruption
References: <CAC=x_0hAQR9Ynmnqohv1R8xv3TBot5wmn7DODx6GbKU7tYv2sA@mail.gmail.com>
	<55E8498F.8090508@sandeen.net>
	<CAC=x_0iUc2VEfW9qChuvUpDk5Kz=wvRGH-1w6sS0XP6CG_ERBQ@mail.gmail.com>
	<55E85F5F.6010005@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <55E871EF.4040603@sandeen.net>
Date: Thu, 3 Sep 2015 11:14:39 -0500
MIME-Version: 1.0
In-Reply-To: <55E85F5F.6010005@sandeen.net>
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
To: Danny Shavit <danny@zadarastorage.com>
Cc: Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

On 9/3/15 9:55 AM, Eric Sandeen wrote:
> On 9/3/15 9:26 AM, Danny Shavit wrote:

...

>> We are using modified xfs. Mainly, added some reporting features and
>> changed discard operation to be aligned with chunk sizes used in our
>> systems. The modified code resides at  https://github.com/zadarastora
>> <https://github.com/zadarastorage/zadara-xfs-pushback>ge/zadara-xfs-pushback
>> <https://github.com/zadarastorage/zadara-xfs-pushback>.
> 
> Interesting, thanks for the pointer.  I guess at this point I have to
> ask, do you see these same problems without your modifications?

Have you ever mounted this filesystem on non-zadara kernels?

looking at
https://github.com/zadarastorage/zadara-xfs-pushback/commit/094df949fd080ede546bb7518405ab873a444823

you've changed the disk format w/o adding a feature flag,
which is pretty dangerous.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
