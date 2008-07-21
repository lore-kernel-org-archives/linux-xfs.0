Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 13:32:36 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6LKWYqx004114
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 13:32:34 -0700
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8C7F8304086
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 13:33:41 -0700 (PDT)
Message-ID: <4884F2A5.5050507@sgi.com>
Date: Mon, 21 Jul 2008 15:33:41 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: xfsrestore over ssh?
References: <2d460de70807211317m75bc236y403d8fa57514262e@mail.gmail.com>
In-Reply-To: <2d460de70807211317m75bc236y403d8fa57514262e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Richard Hartmann <richih.mailinglist@gmail.com>
Cc: xfs@oss.sgi.com

On 07/21/2008 03:17 PM, Richard Hartmann wrote:
> Hi all,
> 
> I am unable to find the correct command to restore a xfs dump
> over ssh. I don't care on which of the two boxes I need to run
> the command, if anyone could tell me either way, that would
> be hugely appreciated!
> 
> 
> Thanks in advance,
> Richard
> 

Something like this should work. Run it from the host that
has the dump file and ssh to the box that needs to have restore.

% cat dumpfile | ssh root@host xfsrestore - /restore/here

Bill
