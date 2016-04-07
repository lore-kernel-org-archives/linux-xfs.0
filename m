Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2E0E97CA0
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 23:10:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 00FE18F8035
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 21:10:20 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id k3PccW4VowKV8kJx (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Apr 2016 21:10:18 -0700 (PDT)
From: Eric Sandeen <esandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_quota: print quota id number if the name can't be
	found
Message-Id: <99CDF6E9-2812-4D24-BB23-7145AD4ED6DF@redhat.com>
Date: Thu, 7 Apr 2016 00:10:16 -0400 (EDT)
References: <1459964353-25151-1-git-send-email-zlang@redhat.com>
	<570556AE.7080306@redhat.com>
	<20160407033713.GA2947@dhcp12-237.nay.redhat.com>
In-Reply-To: <20160407033713.GA2947@dhcp12-237.nay.redhat.com>
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
To: Zorro Lang <zlang@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com



> On Apr 6, 2016, at 10:37 PM, Zorro Lang <zlang@redhat.com> wrote:
> 
>> 
>> 
>>> +        if (name != NULL)
>>> +            fprintf(fp, "%-10s", name);
>>> +        else
>>> +            fprintf(fp, "#%-10u", d.d_id);
> 
> There's one more problem. When we print id number we print #%-10u, but
> for name we print %-10s. There's one more "#" be printed for number.
> So if we print name and number both, the output will like this:
> 
> User ID          Used       Soft       Hard    Warn/Grace
> ---------- --------------------------------------------------
> root           512000          0          0     00 [--------]
> #1000                0     307200     409600     00 [--------]
> 
> You can find the line of #1000 is not align at the line of "root".
> Because the name print 10 characters, but the number print 10
> characters + #.
> 
> Should we fix this problem?
> If fix it, should we make name print %-11s, or make number print
> #%-9u?

9u I think.  Leave the existing format unchanged.

Thx,
Eric

> Thanks,
> Zorro
> 
>>>    }
>>> 
>>>    if (form & XFS_BLOCK_QUOTA) {
>>> @@ -571,6 +574,12 @@ report_project_mount(
>>>            id = oid + 1;
>>>        }
>>>    } else {
>> 
>> Comment:
>> 
>> +        /* Print default project quota even if PRID 0 isn't defined */
>> 
>>> +        if (!getprprid(0)) {
>>> +            report_mount(fp, 0, "#0", NULL, form, XFS_PROJ_QUOTA,
>> 
>> If you pass in NULL instead of "#0" does report_mount do the right thing?
>> If so, better to not hard-code "#0" here.
>> 
>> -Eric
>> 
>>> +                         mount, flags);
>>> +            flags |= NO_HEADER_FLAG;
>>> +        }
>>> +
>>>        setprent();
>>>        while ((p = getprent()) != NULL) {
>>>            if (report_mount(fp, p->pr_prid, p->pr_name, NULL,
>> 
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
