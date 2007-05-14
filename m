Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 May 2007 13:27:49 -0700 (PDT)
Received: from mail.goop.org (gw.goop.org [64.81.55.164])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4EKRkfB013776
	for <xfs@oss.sgi.com>; Mon, 14 May 2007 13:27:47 -0700
Message-ID: <4648C63F.7020800@goop.org>
Date: Mon, 14 May 2007 13:27:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
MIME-Version: 1.0
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
References: <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <20070510004918.GS85884050@sgi.com> <46426D31.8070000@goop.org> <20070510012609.GU85884050@sgi.com> <46433049.4020003@goop.org> <20070510153832.GQ11115@waste.org> <Pine.LNX.4.61.0705121320240.9570@yvahk01.tjqt.qr> <20070512124641.GZ11115@waste.org> <Pine.LNX.4.61.0705142215130.9570@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705142215130.9570@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Matt Mackall <mpm@selenic.com>, David Chinner <dgc@sgi.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, michal.k.k.piotrowski@gmail.com

Jan Engelhardt wrote:
> On May 12 2007 07:46, Matt Mackall wrote:
>   
>>> You should not assume alphabetical order. Filesystems may be free to
>>> reorder things and return them (1) randomly like in a hash (2) by
>>> creation time during readdir().
>>>       
>> There is no assumption. Mercurial explicitly visits files in
>> alphabetical order for the above commands.
>>     
>
> But who says that
>
>   for i in {a..z}; do  ## {..} is a bash3 extension
>     touch $i;
>   done;
>
> actually makes readdir() return them in the same order?

Nobody.  But doing a readdir, sorting the results and visiting the files
in that order does mean you'll visit them in alphabetical order.  Hence
"explicitly visits".

    J
