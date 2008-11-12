Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Nov 2008 23:59:09 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mAC7x23c017471
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2008 23:59:02 -0800
Received: from smtp4.pp.htv.fi (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF853154A52E
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2008 23:59:01 -0800 (PST)
Received: from smtp4.pp.htv.fi (smtp4.pp.htv.fi [213.243.153.38]) by cuda.sgi.com with ESMTP id swPPKtdKcwzzCtj6 for <xfs@oss.sgi.com>; Tue, 11 Nov 2008 23:59:01 -0800 (PST)
Message-ID: <20081112095829.2lhcqttsv4gcocgs@webmail.welho.com>
Date: Wed, 12 Nov 2008 09:58:29 +0200
From: eerov@welho.com
Subject: Re: centos and xfs filesystem shutdowns
References: <491A88F8.8040509@magoazul.com>
In-Reply-To: <491A88F8.8040509@magoazul.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matthew Kent <mkent@magoazul.com>
Cc: xfs@oss.sgi.com

Quoting Matthew Kent <mkent@magoazul.com>:

> Desperately seeking advice :)
>
> The setup:
>
> * CentOS 5.2
> * kmod-xfs-0.4-2 from centosplus repo
> * nfs exporting -> xfs filesystem -> lvm volume -> iscsi target
> * each filesystem is about 750GB and we mount 5 on each server.
> * each filesystem contains 3-20 million small files.
> * mount options are as follows
>   _netdev,noatime,uqnoenforce,gqnoenforce,ihashsize=262139,rw

I also encountered lot of crashes and hangups with Centos 5.2 and XFS  
filesystem.

Solution that worked for me was recompiling latest vanilla kernel and  
installed it into Centos 5.2 system. Maybe some third party provides  
latest vanilla kernel for Centos 5.2 in rpm format?

--
Eero
