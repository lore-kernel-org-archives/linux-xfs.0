Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Nov 2006 06:04:35 -0800 (PST)
Received: from EX01.ad.tulane.edu (ex01.ad.tulane.edu [129.81.114.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kATE4QaG019672
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 06:04:27 -0800
Date: Wed, 29 Nov 2006 08:03:34 -0600
Subject: Re: get xfs_quota info as regular user
From: Rene Salmon <rsalmon@tulane.edu>
Message-ID: <C192EF56.1DC3%rsalmon@tulane.edu>
In-Reply-To: <456CCC77.7000001@sgi.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: xfs@oss.sgi.com

Great that is what I needed!  Thank you
Rene



On 11/28/06 5:55 PM, "Donald Douwsma" <donaldd@sgi.com> wrote:

> Rene Salmon wrote:
>> Hi,
>> 
>> 
>> Did some searches on the list archives but could not find any useful info on
>> this.
>> 
>> Is there a way for a regular user to get info about his or her quota usage?
>> 
>> I tried both of these as a regular user and get nothing:
>> 
>> 120> xfs_quota -c "quota userid"
>> 121> xfs_quota -x -c "quota userid"
> 
> By default the quota command does not display anything unless the user is
> overquota.
> To display the limits set for a user you need to specify the -v option.
> 
> xfs_quota -c 'quota -v'
> 
> Note there is currently a bug in xfs-cmds that causes xfs_quota to display
> results multiple times
> (once for each xfs filesystem). One work around for this is to specify the
> specific filesystem on
> the commandline.
> 
> xfs_quota -c 'quota -v' /home
> 
> Donald
> 
> 

-- 
        Rene Salmon
        Tulane University
        Center for Computational Science
        http://www.ccs.tulane.edu
        rsalmon@tulane.edu
        Tel 504-862-8393
        Fax 504-862-8392
