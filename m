Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q29GtfHK258175 for <xfs@oss.sgi.com>; Fri, 9 Mar 2012 10:55:41 -0600
Received: from webrelay-aldf.mr.itd.umich.edu (webrelay-aldf.mr.itd.umich.edu
	[141.211.14.43]) by cuda.sgi.com with ESMTP id g1onyEHMYxqDLkTE
	for <xfs@oss.sgi.com>; Fri, 09 Mar 2012 08:55:41 -0800 (PST)
Message-ID: <20120309115540.18835d95gar7hecc@web.mail.umich.edu>
Date: Fri, 09 Mar 2012 11:55:40 -0500
From: Sean Thomas Caron <scaron@umich.edu>
Subject: Re: Safe to use XFS in production in Linux 3.2.9?
References: <20120308140600.77406b8zzy2zggkc@web.mail.umich.edu>
	<CAGpXXZLQp+m_soTBw8Zq-M0cyKqVTASSAXMt6YV07ntfqJhMag@mail.gmail.com>
In-Reply-To: <CAGpXXZLQp+m_soTBw8Zq-M0cyKqVTASSAXMt6YV07ntfqJhMag@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="Yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: xfs@oss.sgi.com

Hi Greg,

Yeah, thanks; we've been pointed in the direction of using 3.0-train  
instead, and I'm moving ahead with building 3.0.23. I just didn't see  
any clear guidance on kernel.org so I thought I'd ask about the best  
way to move forward.

Best,

-Sean

Quoting Greg Freemyer <greg.freemyer@gmail.com>:

> On Thu, Mar 8, 2012 at 2:06 PM, Sean Thomas Caron <scaron@umich.edu> wrote:
>
>> Hi all,
>>
>> We're currently using Linux 3.0.12 with Cristoph's xfs-bulletproof-sync
>> patch and it seems to be working very well for us. Unfortunately this
>> kernel is vulnerable to the recent CVE-2012-0056 no permission checking on
>> writes to /proc/(pid)/mem local root exploit, so we've got to leave it
>> behind.
>>
>> I see that the newest recommended stable kernel on kernel.org is 3.2.9.
>>
>
>
> Sean,
>
> You do appreciate 3.0 has been designated a long-term kernel by the
> kernel.org team and will get kernel.org support for 2 years.  3.2 is not a
> long-term kernel, so support drops from kernel.org more or less when 3.3
> comes out.
>
> 3.2 support will come from the distributors of course, but I don't know if
> any of the major releases are based on 3.2.
>
> Greg
>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
