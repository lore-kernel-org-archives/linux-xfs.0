Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D4A314A90
	for <linux-xfs@vger.kernel.org>; Thu,  9 Apr 2026 18:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775760877; cv=none; b=MbyLpluY2QK5mr3C4Y2QpX4YKVNz/ApLcvzzyTmOxPGcm+bDO/lPoOxY9Whj5Uvf+7M65Momv02M0IXbsqQX/97cyzPdwK9gMgUuXDGwC4DISVT7oneg97c3fAlOG3gDnaERdH3ihwx7kGOlasG4bI0s+grZnNmAf8vdTLhSclk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775760877; c=relaxed/simple;
	bh=HITamePOFQ6xKFSAF+Mlb/PmV4vIExJ/NInzdHCOzjo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cpr+G43Kd98f1jMNPXcY5HAFVvvC2nDa9PoPZGaAnocNEIRGRoG0qx0+WEpywfGH9Objd6wx28dne+HFCIrK8eRx9GV3gO8twKh+5ugN2W5Fq5Xvuppi3UCktg3EqrZf+AbEFLDYmHlDCI8mGq86+KWXhFVDQGA8aCJ3TBUKRYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=ZAtJSsKj; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="ZAtJSsKj"
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639Ig3Q31659730
	for <linux-xfs@vger.kernel.org>; Thu, 9 Apr 2026 14:54:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=sw6G
	wRk7Qp2WRM++iKaHx+hBQAaMKviN9vTfKu8ETKo=; b=ZAtJSsKjbJ+Hx52hia8V
	5BMqLKGKSsStdVWtGKARsi0D128R4JPKsI86AourUUAoTURwWTj35qcQxipX3bWP
	a6q3sdKorNc6YRrCwTJb/TCMxv3p+mxXbU/gTz0zRx16uUBEfpyeh9ojfIrrl1aq
	v46cmPYqZ9ZsuXvF5ZJpb2hQ0JPDNtX0YlfISoHeTAQyYnZZ09MubrDOhccs0Z3H
	/91KAb3XVWlenwMNgfnasO8BAjtbph26AK473sh5c15lh7ocLkyw8qQDtKZiOtI3
	kyLlhC3ioSigG1ElxYY76Q5lLYGJj27fPkR12FO/wB9Z+gml0Y8wUuiIjTb8Ele2
	7g==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4dee5fjdqf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Thu, 09 Apr 2026 14:54:29 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-89ebd9e1ee4so23976326d6.1
        for <linux-xfs@vger.kernel.org>; Thu, 09 Apr 2026 11:54:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775760869; x=1776365669;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sw6GwRk7Qp2WRM++iKaHx+hBQAaMKviN9vTfKu8ETKo=;
        b=bLwXb9/X2fGSyLKSIMLPUlALhYJBFTqpFOyOQ7Kcm2YQtQMj6B1SAbvkDudt1fEI5o
         aVyrB1T4LYJgQkENIl7iSR42QpFsMIq7NbdPv6UmcHtcRDFLPJLQrsP5VulT2I5aWUC7
         jLtip3fbsUY0pBHcGu/SvZ/WCyzukfBJeuvwBNA5UugzJ5rxy3LP63WsIH8Zcy5OkY6c
         KRm5TThSEhpSXTgje2LUc8aepr6GsDmTnDpNIbBwpv68GMM5S+QubDn/r8GgInMI6Htn
         Ils+1qslNKRW3WOy3AXV5KINOpdJfyJ2WsWYczQSaGIGf5PI/0Ked+vohs2AtovLcwnY
         j9Dw==
X-Forwarded-Encrypted: i=1; AJvYcCU1OVOEz+kbyn6Nlhwj48NfKhcI2sWeJiLy3gjS5qqdSCkk4gm/IM2lPM97+LjnkNM4kLPDbpqju6E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBtxBf6RBGB4yHM6OPc0CwwdOY0BxKGWLcD57/n3qlCMehxDyA
	qgSqzpo5Fw4Rz1A4G37VjX0IHg6ftZB0UJGiF6V3UBR4d12HyGjrc4C7I8mNKUnpBD1CRGfrplX
	JwaZxoc1A5E2UuSA4owJxJstI66SIhQZn0U6J4YC2r0BqhARfoE+AoUcY1g==
X-Gm-Gg: AeBDietT1XQRqLTX8GvXfCOkrTv7Hy6G6tPL5/4E1H73SSqWjqm5RUDp3+CEfIgCNad
	TzSfPQBpcZyEKTcm4Q/Qr0RkX+nglMZUqJDdpjheJl4IXc7zWoHoxFLYmWTKJRq1udVdnFauiek
	Gcmsx3mN0RdwTtHrThC5VIl5e1TjfNzNOkdmFaFB03JjghwY5XcYk3EBegGwD1J37yuwvwjF4kj
	lrFj02/b/M2q/mqz0vJ6eVTXA1DMFIfhDpXvSHxugJfRn1Rwbg03cK/7jjfuc2cynmjcWEDQDvL
	tyJdIWg/YMlPlovWIxlIuK4ZR93GvDUr4TVxngPCqahyGgd/2FZZf7spRmhq12QmbGd4bD64sbw
	D0vwCn8nID3gC1ebPAjkPIr5hAbw74tX0j7X/bh3f
X-Received: by 2002:a0c:f114:0:b0:8a3:221d:9095 with SMTP id 6a1803df08f44-8ac743038b7mr72761236d6.15.1775760868936;
        Thu, 09 Apr 2026 11:54:28 -0700 (PDT)
X-Received: by 2002:a0c:f114:0:b0:8a3:221d:9095 with SMTP id 6a1803df08f44-8ac743038b7mr72760866d6.15.1775760868507;
        Thu, 09 Apr 2026 11:54:28 -0700 (PDT)
Received: from [10.206.71.59] ([129.236.231.31])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac849db4b8sm3093516d6.7.2026.04.09.11.54.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 11:54:27 -0700 (PDT)
Message-ID: <7e468bd2-e52b-4165-95c6-3f04e1dca21e@columbia.edu>
Date: Thu, 9 Apr 2026 14:54:27 -0400
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
To: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <97b81868-6410-4c79-a242-679a9f04f073@columbia.edu>
 <95F28FA1-5CEF-4E80-BBB7-A429B4437D12@kernel.dk>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <95F28FA1-5CEF-4E80-BBB7-A429B4437D12@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: JE9s_ChNr3poc88-rnFvqQ0-lO-rPc9T
X-Authority-Analysis: v=2.4 cv=McxcfZ/f c=1 sm=1 tr=0 ts=69d7f5e5 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=RFpAoTwO7tzpE9r8PTiuXw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=y2ETOFklOQM5vU7YwEUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDE3MyBTYWx0ZWRfXy+A5fKmmq+A6
 F3NWadRKUSuKzRyzPWCVOYOMp/vJ+ajZFCoK6iZXaDw18MQyX1M6jR6GyDp+rVJaJakj28mud0/
 dYTefF2c2i5z+5xpzQvrDEpMaH/9cZgGTZjsXIAdL1s4bov5SOlE2nxNowC8uxpsnAix74M1EYa
 NsWe7kyLqNDXYL4QIvAwsJaIqMbvQziJ86waHYuZFoBMGoPJ2D2v7HjH1gqCGaUHbmreAHWIDdB
 xeFoLCVb27TXjQ/8UL0cDgs2Ha0eu/6ms6Fco+kI0CvXBpyCvWjTGnqtmC2YkWcd9IWK40m2s59
 Yb7k8nsIZCge8FcnORgFmC8ua5Js3vVXdaL99Jy672GHUMHg4O4oIsliBBRBPaMO0uVFBuDW6Zv
 TWdV7OFYZTbUr9jV7qPPVUnSnzwnhuGI+ibm5FIAxy/pNr8p7mGTVdBddYNPAyS0IhF3N7R/48N
 JFAxMw5cFO3YJqwhGEw==
X-Proofpoint-ORIG-GUID: JE9s_ChNr3poc88-rnFvqQ0-lO-rPc9T
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11754
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 phishscore=0 lowpriorityscore=10 suspectscore=0 spamscore=0
 bulkscore=10 priorityscore=1501 malwarescore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090173



On 4/8/26 7:36 PM, Jens Axboe wrote:
> On Apr 8, 2026, at 4:51 PM, Tal Zussman <tz2294@columbia.edu> wrote:
>>> On 4/8/26 3:51 PM, Jens Axboe wrote:
>>>> On 4/8/26 12: 48 PM, Tal Zussman wrote: > On 3/25/26 4: 14 PM, Jens Axboe wrote:
>>>> 
>>>> Thanks! I'm going to give Dave's llist suggestion a shot on top of
>>>> this as it seems like it'll simplify this nicely. Looks like that'll
>>>> involve turning bio::bi_next into a union with a struct llist_node.
>>> 
>>> Since these lists can get long, I'd keep an eye on llist reversal
>>> overhead there...
>>> 
>> 
>> Going to send v5 shortly -- tested with and without the llist reversal and
>> it didn't seem to make much of a difference. This was on a single-disk VM
>> though, so any stress testing you could do would be very helpful.
>> 
> 
> With all due respect, a single test like that isn’t going to be that useful. I’d be wary of making that change willy nilly and just thinking “it’s fine, worked fine on the one case I tested”.

Understood -- unfortunately that's what I have access to at the moment. I
can requisition a machine with 2, maybe 3 disks, and test more thoroughly on
that before sending the next version, but that'll take a few days. You had
previously offered to test on your big box, so was hoping that was still on
the table :)
(Although Christoph seems to have proposed moving away from llist again)

> —
> Jens Axboe
> 

