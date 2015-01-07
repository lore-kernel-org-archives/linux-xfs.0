Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B13FE7F66
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 00:01:56 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 906938F8033
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 22:01:53 -0800 (PST)
Received: from mail-yk0-f177.google.com (mail-yk0-f177.google.com
	[209.85.160.177]) by cuda.sgi.com with ESMTP id
	nExEatPUTHCRSlm1 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 22:01:51 -0800 (PST)
Received: by mail-yk0-f177.google.com with SMTP id 9so323173ykp.8
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2015 22:01:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54ACC4C0.2030802@sandeen.net>
References: <1806495.BCZcrVVEOf@shtub-cm> <54AC1511.1060908@sandeen.net>
	<CAJCQCtQqseJ_75WSjqqNMmSjYW-0-L_cWBDDECRVOkiTmHLeVA@mail.gmail.com>
	<54AC363E.1090109@sandeen.net>
	<CAJCQCtRUq9ozu74TBjm4G-yoC0kQa7Vr8nUTNzke6O7DTWQPXw@mail.gmail.com>
	<CAJCQCtS8M5w76bzr4TzB9CQo+tTOwsfAu8+x5h7p9W_RMfEgFA@mail.gmail.com>
	<54ACC4C0.2030802@sandeen.net>
Date: Tue, 6 Jan 2015 23:01:51 -0700
Message-ID: <CAJCQCtTA6ieugXWqh3QLddM5y+j9v80bN8_1u7uRfSzeU=1Lsg@mail.gmail.com>
Subject: Re: What is a recommended XFS sector size for hybrid (512e) advanced
	format hard drives?
From: Chris Murphy <lists@colorremedies.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Chris Murphy <lists@colorremedies.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Jan 6, 2015 at 10:31 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 1/6/15 1:55 PM, Chris Murphy wrote:
>> What's sectsz= used for? Historically this would be sectsz=512,
>> bsize=4096 before AF hard drives appeared. So is sectsz used for
>> optimizing sub blocksize changes? e.g. if only 50 bytes needs
>> changing, the fs doesn't need to read modify and write the entire 4096
>> block, just change the affected sector?
>
> Nope, filesystem data blocks are always fully written, but the sector
> size is i.e. the minimum _log_ IO size.

So maybe the people reporting performance problems with sectsz=512 on
AF drives compared to manually specifying 4096 bytes, have a high
metadata workload with older AF drives and are getting lot of in-drive
RMW...


-- 
Chris Murphy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
