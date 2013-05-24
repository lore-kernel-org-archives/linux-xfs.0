Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9B9467CBF
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 09:09:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2D898AC004
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 07:09:30 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id tLha15amEjpYxA94 for <xfs@oss.sgi.com>;
	Fri, 24 May 2013 07:09:29 -0700 (PDT)
Message-ID: <519F7498.8020500@sandeen.net>
Date: Fri, 24 May 2013 09:09:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Intermittent crashes - xfs_repair finds no errors
References: <CANU9nTnbA8WLK68X4yLFODiBZZgT4xX9U6fEmCHp+0+BMb6XQQ@mail.gmail.com>
	<20130524151022.160656e9@harpe.intellique.com>
In-Reply-To: <20130524151022.160656e9@harpe.intellique.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com, Ole Tange <tange@binf.ku.dk>

On 5/24/13 8:10 AM, Emmanuel Florac wrote:
> Le Fri, 24 May 2013 11:59:02 +0200
> Ole Tange <tange@binf.ku.dk> =E9crivait:
> =

>> # uname -a
>> Linux lemaitre 3.2.0-0.bpo.1-amd64 #1 SMP Sat Feb 11 08:41:32 UTC 2012
>> x86_64 GNU/Linux
>>
>> May 13 11:43:31 lemaitre kernel: [507964.074856] XFS (md3): metadata
>> I/O error: block 0x18dcf8 ("xfs_trans_read_buf") error 5 buf count
>> 4096

"metadata IO error" kind of speaks for itself.  And error 5 is EIO.

It looks for all the world like you are getting read errors from the device.

> What are the few previous lines of /var/log/messages before these?
> There could be some hardware related message, or some hint of corrupted
> metadata.

Yep, full dmesg might be good.

tracing on

xfs_trans_read_buf_io
and
xfs_buf_read

might give some insight if dmesg doesn't.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
