Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Mar 2007 20:22:03 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-4.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2M3Lv6p010028
	for <xfs@oss.sgi.com>; Wed, 21 Mar 2007 20:21:59 -0700
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by netops-testserver-4.corp.sgi.com (Postfix) with ESMTP id 9A2F861BBE
	for <xfs@oss.sgi.com>; Wed, 21 Mar 2007 19:04:53 -0800 (PST)
Message-ID: <4601F9EB.30201@sgi.com>
Date: Wed, 21 Mar 2007 21:37:15 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: But wait, theres more... [Fwd: Bug#415123: -R option can't append
 to a plain file]
References: <1174252993.5051.233.camel@edge> <17CB3A8C59A80064581C0A32@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <17CB3A8C59A80064581C0A32@timothy-shimmins-power-mac-g5.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: nscott@aconex.com, xfs@oss.sgi.com

Tim summed it up pretty well. I'd agree it's more of
a feature request. In case it isn't clear, the way
to resume a dump to a regular file is to point xfsdump
at a new file, just like incremental dumps go in a
different file than the base dump.

Bill

Timothy Shimmin wrote:
> Hi,
> 
> I'll leave this to Bill. Just a couple of comments.
> 
> I don't know if you can call it a "bug", more of a restriction.
> There is a layer provided for the I/O using drive_*.c -
> i.e drive_scsitape.c, drive_minrmt.c, drive_simple.c (which show up
> as a "drive strategy" on output).
> As part of the ds_instantiate() interface one typically sets up the 
> d_capabilities
> that this drive strategy supports and for files (drive_simple), 
> DRIVE_CAP_APPEND is
> not given. What the ramifications for drive_simple (file strategy) are,
> I wouldn't know without looking at the code and playing with it.
> But I'd call it an RFE :)
> 
> --Tim
> 
> --On 19 March 2007 8:23:13 AM +1100 Nathan Scott <nscott@aconex.com> wrote:
> 
>> And a free set of steak knives if you fix this bug...  ;-)
>>
>> -------- Forwarded Message --------
>> From: Peter Chubb <peterc@gelato.unsw.edu.au>
>> Reply-To: Peter Chubb <peterc@gelato.unsw.edu.au>,
>> 415123@bugs.debian.org
>> To: submit@bugs.debian.org
>> Subject: Bug#415123: -R option can't append to a plain file
>> Date: Fri, 16 Mar 2007 19:54:37 +1100
>>
>> Package: xfsdump
>> Version: 2.2.38-1
>>
>> If I use xfsdump to dump to a plain file, interrupt it, then restart
>> with the -R option, xfsdump complains:
>>
>> xfsdump: ERROR: media contains valid xfsdump but does not support append
>>
>> which is misleading: of *course* you can append to a regular file if
>> there's space on the filesystem.
>>
>> -- 
>> Dr Peter Chubb  http://www.gelato.unsw.edu.au  peterc AT 
>> gelato.unsw.edu.au
>> http://www.ertos.nicta.com.au           ERTOS within National ICT 
>> Australia
>>
>> -- 
>> Nathan
>>
> 
> 
> 
