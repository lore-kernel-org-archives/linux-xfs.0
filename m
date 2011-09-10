Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8AIB6ut120675 for <xfs@oss.sgi.com>; Sat, 10 Sep 2011 13:11:06 -0500
Received: from mx0a-00082601.pphosted.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7485714C21E
	for <xfs@oss.sgi.com>; Sat, 10 Sep 2011 11:11:04 -0700 (PDT)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com
	[67.231.145.42]) by cuda.sgi.com with ESMTP id H2KqjbOq4t270XgK
	for <xfs@oss.sgi.com>; Sat, 10 Sep 2011 11:11:04 -0700 (PDT)
From: Paul Saab <ps@fb.com>
Subject: Re: Performance regression between 2.6.32 and 2.6.38
Date: Sat, 10 Sep 2011 18:10:50 +0000
Message-ID: <CA90F616.8E617%ps@fb.com>
In-Reply-To: <20110910060522.GA26968@infradead.org>
Content-Language: en-US
Content-ID: <6F250799357E9F4BA6F92AF018E8C947@fb.com>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>, Joshua Aune <luken@fusionio.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 9/9/11 11:05 PM, "Christoph Hellwig" <hch@infradead.org> wrote:

>On Fri, Sep 09, 2011 at 06:23:54PM -0600, Joshua Aune wrote:
>> Are there any mount options or other tests that can be run in the
>>failing configuration that would be helpful to isolate this further?
>
>The best thing would be to bisect it down to at least a kernel release,
>and if possible to a -rc or individual change (the latter might start
>to get hard due to various instabilities in early -rc kernels)

487f84f3 is where the regression was introduced.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
