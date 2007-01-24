Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Jan 2007 08:53:11 -0800 (PST)
Received: from moving-picture.com (mpc-26.sohonet.co.uk [193.203.82.251])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0OGr2qw026218
	for <xfs@oss.sgi.com>; Wed, 24 Jan 2007 08:53:05 -0800
Received: from minion.mpc.local ([172.16.11.112] helo=moving-picture.com)
	by moving-picture.com with esmtp (Exim 4.43)
	id 1H9kzB-0003GM-KA
	for xfs@oss.sgi.com; Wed, 24 Jan 2007 16:28:33 +0000
Message-ID: <45B78931.6030809@moving-picture.com>
Date: Wed, 24 Jan 2007 16:28:33 +0000
From: James Pearson <james-p@moving-picture.com>
MIME-Version: 1.0
Subject: Re: how to sync / commit data to disk?
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

>> grub is broken
>> 
>> this comes up all the time, there are various work-arounds but it
>> doesn't change the fact that GRUB IS BROKEN
>> 
>> it would be nice if someone would just address it from that end
>> 
>> > xfs_freeze -f
>> > sync
>> > xfs_freeze -u
>> 
>> sync before freeze (actually, I'm not sure a sync there is necessary
>> but it can't hurt)
> 
> Its not necessary (would be a bug if so).
> 
> FWIW, this hack can be better achieved in a filesystem independent way
> by doing a remount,ro ... remount,rw instead of freeze/thaw.

This is the way that I do it - based on info in an earlier posting on 
this list:

<http://marc.theaimsgroup.com/?l=linux-xfs&m=112096901910385&w=2>

James Pearson
