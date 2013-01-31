Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 750447F50
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 01:35:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 53DC48F8039
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 23:35:54 -0800 (PST)
Received: from mail-ye0-f174.google.com (mail-ye0-f174.google.com
	[209.85.213.174]) by cuda.sgi.com with ESMTP id
	ZQ7vPuyWt69BLVS2 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Jan 2013 23:35:53 -0800 (PST)
Received: by mail-ye0-f174.google.com with SMTP id m3so490651yen.5
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 23:35:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130130234650.GE32297@disturbed.disaster>
References: <32271.192.104.24.222.1359415698.squirrel@secure.skymagik.net>
	<20130129151833.GF27055@sgi.com>
	<42720.75.149.17.233.1359515780.squirrel@secure.skymagik.net>
	<20130130234650.GE32297@disturbed.disaster>
Date: Thu, 31 Jan 2013 08:35:52 +0100
Message-ID: <CAAxjCEytb-Rgc6qXiUudy2vKksF6dfjwNsmF9eoLmoQBnnOgPw@mail.gmail.com>
Subject: Re: XFS appears to cause strange hang with md raid1 on reboot
From: Stefan Ring <stefanrin@gmail.com>
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
To: Tom <storm9c1@skymagik.com>, xfs@oss.sgi.com

> So the filesystems are unmounted....
>
> And this says the filesystem is still mounted. Why?

When I last had a problem with shutdown, it was because of mount
namespaces. You can unmount all day long, but as long as there is a
mount still open in a namespace, nothing will get unmounted. This was
on Fedora though; don't know if RHEL 5.x makes use of namespaces.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
