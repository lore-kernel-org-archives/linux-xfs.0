Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AC89E7F3F
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2014 04:30:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9DCB68F8068
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2014 02:30:19 -0700 (PDT)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
	[209.85.212.175]) by cuda.sgi.com with ESMTP id
	9w1L6mWUugn3E52f (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 09 Jul 2014 02:30:17 -0700 (PDT)
Received: by mail-wi0-f175.google.com with SMTP id ho1so2378795wib.8
	for <xfs@oss.sgi.com>; Wed, 09 Jul 2014 02:30:16 -0700 (PDT)
Received: from [10.34.1.157] (nat-pool-brq-t.redhat.com. [209.132.186.34])
	by mx.google.com with ESMTPSA id i4sm17227753wib.21.2014.07.09.02.30.14
	for <xfs@oss.sgi.com> (version=TLSv1 cipher=RC4-SHA bits=128/128);
	Wed, 09 Jul 2014 02:30:14 -0700 (PDT)
Message-ID: <1404898212.7231.12.camel@jtulak>
Subject: symlink loop for /lib64/libhandle.so
From: Jan =?UTF-8?Q?=C5=A4ul=C3=A1k?= <jan@tulak.me>
Date: Wed, 09 Jul 2014 11:30:12 +0200
Mime-Version: 1.0
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
To: XFS mail list <xfs@oss.sgi.com>

Hi,

when I install xfsprogs from Git, I get a symlink loop:
$ ls -l /lib64/libhandle.so
lrwxrwxrwx. 1 root root 19 Jul  9 09:56 /lib64/libhandle.so
-> /lib64/libhandle.so

I guess it should point to libhandle.so.1.


I'm using this repo: git://oss.sgi.com/xfs/cmds/xfsprogs
And just the usual "make && sudo make install" commands.

Also, I have made sure the libhandle library was not installed before
this installation.


Used HW/SW:
- A virtual machine in KVM.
- Fedora 20 x86_64

If it not an intended behavior, I can try to find the source of the bug
and make a patch (I'm new here :-).

Thanks,
Jan Tulak

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
